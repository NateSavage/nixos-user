using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;

var isWindows = RuntimeInformation.IsOSPlatform(OSPlatform.Windows);

string configDir = isWindows
    ? Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData)
    : Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), ".config");

var folders = new Dictionary<string, string>
{
    [Path.Combine(configDir, isWindows ? "Zed" : "zed")] = Path.Combine("dotfiles", ".config", "zed"),
    [Path.Combine(isWindows
        ? Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData)
        : configDir, "nvim")] = Path.Combine("dotfiles", ".config", "nvim"),
};

foreach (var (src, dst) in folders)
{
    if (!Directory.Exists(src))
    {
        Console.WriteLine($"Skipping {src} (not found)");
        continue;
    }

    if (Directory.Exists(dst)) Directory.Delete(dst, recursive: true);
    Directory.CreateDirectory(dst);

    foreach (var file in Directory.EnumerateFiles(src, "*", SearchOption.AllDirectories))
    {
        var relative = Path.GetRelativePath(src, file);
        var destFile = Path.Combine(dst, relative);
        Directory.CreateDirectory(Path.GetDirectoryName(destFile)!);
        File.Copy(file, destFile, overwrite: true);
    }

    Console.WriteLine($"Copied {src} -> {dst}");
}

Run("git", "reset HEAD");
Run("git", "add dotfiles/");
Run("git", "commit -m \"Updated Dotfiles\"");
Run("git", "push");

static void Run(string cmd, string args)
{
    var psi = new ProcessStartInfo(cmd, args) { UseShellExecute = false };
    using var p = Process.Start(psi)!;
    p.WaitForExit();
    if (p.ExitCode != 0) throw new Exception($"`{cmd} {args}` exited with code {p.ExitCode}");
}
