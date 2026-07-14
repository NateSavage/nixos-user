using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;



bool isWindows = RuntimeInformation.IsOSPlatform(OSPlatform.Windows);

Dictionary<string, string> toStore = GetStorageItems(isWindows);

foreach (var (src, dst) in toStore) {
    // check if file or Directory exists

    // source is file
    if (File.Exists(src)) {
        Directory.Createdirectory(path.GetDirectoryName(dst));
        var resolved = File.ResolveLinkTarget(src, returnfinaltarget: true)?.fullname ?? src;
        file.copy(resolved, dst, overwrite: true);
        console.writeline($"copied {src} -> {dst}");
        continue;
    }

    // source doesn't exist
    if (!Directory.Exists(src)) {
        Console.WriteLine($"skipping {src} (not found)");
        continue;
    }
    
    // source is a directory, clear destination directory to prep for copy
    if (Directory.Exists(dst)) Directory.Delete(dst, recursive: true);
    Directory.CreateDirectory(dst);

    foreach (var file in Directory.EnumerateFiles(src, "*", SearchOption.AllDirectories)) { 
        var relative = Path.GetRelativePath(src, file);
        var destFile = Path.Combine(dst, relative);
        Directory.CreateDirectory(Path.GetDirectoryName(destFile)!);
        var resolved = File.ResolveLinkTarget(file, returnFinalTarget: true)?.FullName ?? file;
        File.Copy(resolved, destFile, overwrite: true);
    }

    Console.WriteLine($"Copied {src} -> {dst}");
}

RunShellCommand("git", "reset HEAD");
RunShellCommand("git", "add dotfiles/");
RunShellCommand("git", "commit -m \"Updated Config Files\"");
RunShellCommand("git", "push");

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
            [Path.Combine(home, ".gitconfig")]        = Path.Combine("config-files", ".gitconfig"),
            [Path.Combine(home, ".ssh")]              = Path.Combine("config-files", ".ssh"),
            [Path.Combine(home, ".config", "nvim")]   = Path.Combine("config-files", ".config", "nvim"),
            [Path.Combine(home, ".config", "yazi")]   = Path.Combine("config-files", ".config", "yazi"),
            [Path.Combine(home, ".config", "zed")]    = Path.Combine("config-files", ".config", "zed"),
        };
    }
    else {
        string appData = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
        string localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);

        return new Dictionary<string, string>() {
            [Path.Combine(home, ".gitconfig")]        = Path.Combine("config-files", ".gitconfig"),
            [Path.Combine(home, ".ssh")]              = Path.Combine("config-files", ".ssh"),
            [Path.Combine(localAppData, "nvim")]      = Path.Combine("config-files", ".config", "nvim"),
            [Path.Combine(appData, "yazi", "config")] = Path.Combine("config-files", ".config", "yazi"),
            [Path.Combine(appData, "Zed")]            = Path.Combine("config-files", ".config", "zed"),
        };
    };
}

