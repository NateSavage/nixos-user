using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;

var isWindows = RuntimeInformation.IsOSPlatform(OSPlatform.Windows);
var username = args.Length > 0 ? args[0] : Environment.UserName;
var appData = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
var localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);

if (isWindows) {
    var home = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);

    // Repo source -> app config destination mappings
    var items = new Dictionary<string, string> {
        [Path.Combine("dotfiles", ".config", "zed")]           = Path.Combine(appData, "Zed"),
        [Path.Combine("dotfiles", ".config", "nvim")]          = Path.Combine(localAppData, "nvim"),
        [Path.Combine("dotfiles", ".config", "yazi")]          = Path.Combine(appData, "yazi", "config"),
        [Path.Combine("dotfiles", ".config", "starship.toml")] = Path.Combine(home, ".config", "starship.toml"),
    };

    foreach (var (src, dst) in items) {
        // source is a single file
        if (File.Exists(src)) {
            Directory.CreateDirectory(Path.GetDirectoryName(dst)!);
            File.Copy(src, dst, overwrite: true);
            Console.WriteLine($"Copied {src} -> {dst}");
            continue;
        }

        if (!Directory.Exists(src)) {
            Console.WriteLine($"Skipping {src} (not found)");
            continue;
        }

        if (Directory.Exists(dst)) DeleteDirectory(dst);
        Directory.CreateDirectory(dst);

        foreach (var file in Directory.EnumerateFiles(src, "*", SearchOption.AllDirectories)) {
            var relative = Path.GetRelativePath(src, file);
            var destFile = Path.Combine(dst, relative);
            Directory.CreateDirectory(Path.GetDirectoryName(destFile)!);
            File.Copy(file, destFile, overwrite: true);
        }

        Console.WriteLine($"Copied {src} -> {dst}");
    }
}
else {
    var home = $"/home/{username}";
    Run("sudo", $"find {home} -type l -lname \"/nix/store/*/dotfiles/*\" -delete");
    Run("sudo", "systemd-tmpfiles --create");
}

static void DeleteDirectory(string path) {
    foreach (var file in Directory.EnumerateFiles(path, "*", SearchOption.AllDirectories))
        File.SetAttributes(file, FileAttributes.Normal);
    Directory.Delete(path, recursive: true);
}

static void Run(string cmd, string args) {
    var psi = new ProcessStartInfo(cmd, args) { UseShellExecute = false };
    using var process = Process.Start(psi)!;
    process.WaitForExit();
    if (process.ExitCode != 0) throw new Exception($"`{cmd} {args}` exited with code {process.ExitCode}");
}
