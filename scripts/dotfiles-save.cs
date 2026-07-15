using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;



bool isWindows = RuntimeInformation.IsOSPlatform(OSPlatform.Windows);

Dictionary<string, string> toStore = GetStorageItems(isWindows);

foreach (var (src, dst) in toStore) {
    // check if file or Directory exists

    // source is file
    if (File.Exists(src)) {
        var resolved = File.ResolveLinkTarget(src, returnFinalTarget: true)?.FullName ?? src;
        if (IsPrivateKeyFile(resolved)) {
            Console.WriteLine($"Refusing to copy {src} -> {dst}: looks like a private key");
            continue;
        }
        Directory.CreateDirectory(Path.GetDirectoryName(dst)!);
        File.Copy(resolved, dst, overwrite: true);
        Console.WriteLine($"Copied {src} -> {dst}");
        continue;
    }

    // source doesn't exist
    if (!Directory.Exists(src)) {
        Console.WriteLine($"skipping {src} (not found)");
        continue;
    }
    
    // source is a directory, clear destination directory to prep for copy
    if (Directory.Exists(dst)) DeleteDirectory(dst);
    Directory.CreateDirectory(dst);

    foreach (var file in Directory.EnumerateFiles(src, "*", SearchOption.AllDirectories)) {
        var resolved = File.ResolveLinkTarget(file, returnFinalTarget: true)?.FullName ?? file;
        if (IsPrivateKeyFile(resolved)) {
            Console.WriteLine($"Refusing to copy {file}: looks like a private key");
            continue;
        }
        var relative = Path.GetRelativePath(src, file);
        var destFile = Path.Combine(dst, relative);
        Directory.CreateDirectory(Path.GetDirectoryName(destFile)!);
        File.Copy(resolved, destFile, overwrite: true);
    }

    Console.WriteLine($"Copied {src} -> {dst}");
}

// Final safety net: even if a mapping above ever gets careless, refuse to
// stage/commit anything under dotfiles/ that looks like a private key.
var suspicious = Directory.EnumerateFiles("dotfiles", "*", SearchOption.AllDirectories)
    .Where(IsPrivateKeyFile)
    .ToList();
if (suspicious.Count > 0) {
    Console.WriteLine("Aborting: possible private key(s) found in dotfiles/:");
    foreach (var f in suspicious) Console.WriteLine($"  {f}");
    throw new Exception("Refusing to commit/push: private key material detected in dotfiles/.");
}

RunShellCommand("git", "reset HEAD");
RunShellCommand("git", "add dotfiles/");
RunShellCommand("git", "commit -m \"Updated Config Files\"");
RunShellCommand("git", "push");

static void DeleteDirectory(string path) {
    foreach (var file in Directory.EnumerateFiles(path, "*", SearchOption.AllDirectories))
        File.SetAttributes(file, FileAttributes.Normal);
    Directory.Delete(path, recursive: true);
}

// Filename patterns and PEM/OpenSSH/PuTTY content markers for common private key formats.
static readonly string[] PrivateKeyNames = {
    "id_rsa", "id_dsa", "id_ecdsa", "id_ed25519", "id_ed25519_sk", "id_ecdsa_sk",
};

static readonly string[] PrivateKeyExtensions = { ".pem", ".key", ".ppk" };

static readonly string[] PrivateKeyContentMarkers = {
    "-----BEGIN OPENSSH PRIVATE KEY-----",
    "-----BEGIN RSA PRIVATE KEY-----",
    "-----BEGIN DSA PRIVATE KEY-----",
    "-----BEGIN EC PRIVATE KEY-----",
    "-----BEGIN PRIVATE KEY-----",
    "-----BEGIN ENCRYPTED PRIVATE KEY-----",
    "PuTTY-User-Key-File-",
};

static bool IsPrivateKeyFile(string path) {
    var name = Path.GetFileName(path);

    // Public keys and known_hosts-style files are fine; everything else matching
    // a known private-key name/extension is treated as a key.
    if (!name.EndsWith(".pub", StringComparison.OrdinalIgnoreCase)) {
        if (PrivateKeyNames.Contains(name)) return true;
        if (PrivateKeyExtensions.Any(ext => name.EndsWith(ext, StringComparison.OrdinalIgnoreCase))) return true;
    }

    // Content sniff catches anything with a nonstandard name (e.g. a renamed key).
    try {
        using var reader = new StreamReader(path);
        var buffer = new char[4096];
        int read = reader.ReadBlock(buffer, 0, buffer.Length);
        var head = new string(buffer, 0, read);
        if (PrivateKeyContentMarkers.Any(marker => head.Contains(marker))) return true;
    }
    catch (Exception) {
        // Unreadable/binary/locked - filename check above already ran; nothing more to do.
    }

    return false;
}

static void RunShellCommand(string cmd, string args) {
    var psi = new ProcessStartInfo(cmd, args) { UseShellExecute = false };
    using var process = Process.Start(psi)!;
    process.WaitForExit();
    if (process.ExitCode != 0) 
        throw new Exception($"`{cmd} {args}` exited with code {process.ExitCode}");
}

///<returns>
/// A dictionary where the key is an absolute path to a file or folder on the OS we want to save. <br/>
/// The value is a local path where we want to copy to.
///</returns>
static Dictionary<string, string> GetStorageItems(bool platformIsWindows) {
    string home = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);

    if (!platformIsWindows) {
        return new Dictionary<string, string>() {
            [Path.Combine(home, ".gitconfig")]         = Path.Combine("dotfiles", ".gitconfig"),
            [Path.Combine(home, ".ssh", "config")]     = Path.Combine("dotfiles", ".ssh", "config"),
            [Path.Combine(home, ".config", "nvim")]   = Path.Combine("dotfiles", ".config", "nvim"),
            [Path.Combine(home, ".config", "yazi")]   = Path.Combine("dotfiles", ".config", "yazi"),
            [Path.Combine(home, ".config", "zed")]    = Path.Combine("dotfiles", ".config", "zed"),
        };
    }
    else {
        string appData = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
        string localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);

        return new Dictionary<string, string>() {
            [Path.Combine(home, ".gitconfig")]         = Path.Combine("dotfiles", ".gitconfig"),
            [Path.Combine(home, ".ssh", "config")]     = Path.Combine("dotfiles", ".ssh", "config"),
            [Path.Combine(localAppData, "nvim")]      = Path.Combine("dotfiles", ".config", "nvim"),
            [Path.Combine(appData, "yazi", "config")] = Path.Combine("dotfiles", ".config", "yazi"),
            [Path.Combine(appData, "Zed")]             = Path.Combine("dotfiles", ".config", "zed"),
        };
    };
}

