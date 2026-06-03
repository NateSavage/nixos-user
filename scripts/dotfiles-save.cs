using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;

var isWindows = RuntimeInformation.IsOSPlatform(OSPlatform.Windows);
var appData = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
var localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
var home = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);

// Source -> repo destination mappings, keyed by platform
var folders = isWindows
    ? new Dictionary<string, string>
    {
        [Path.Combine(appData, "Zed")]           = Path.Combine("dotfiles", ".config", "zed"),
        [Path.Combine(localAppData, "nvim")]     = Path.Combine("dotfiles", ".config", "nvim"),
        [Path.Combine(appData, "yazi", "config")]= Path.Combine("dotfiles", ".config", "yazi"),
    }
    : new Dictionary<string, string>
    {
        [Path.Combine(home, ".config", "nvim")]  = Path.Combine("dotfiles", ".config", "nvim"),
        [Path.Combine(home, ".config", "zed")]   = Path.Combine("dotfiles", ".config", "zed"),
        [Path.Combine(home, ".config", "yazi")]  = Path.Combine("dotfiles", ".config", "yazi"),
        [Path.Combine(home, ".ssh")]             = Path.Combine("dotfiles", ".ssh"),
        [Path.Combine(home, ".gitconfig")]       = Path.Combine("dotfiles", ".gitconfig"),
    };

foreach (var (src, dst) in folders)
{
    // Single file
    if (File.Exists(src))
    {
        Directory.CreateDirectory(Path.GetDirectoryName(dst)!);
        var resolved = File.ResolveLinkTarget(src, returnFinalTarget: true)?.FullName ?? src;
        File.Copy(resolved, dst, overwrite: true);
        Console.WriteLine($"Copied {src} -> {dst}");
        continue;
    }

    // Directory
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
        var resolved = File.ResolveLinkTarget(file, returnFinalTarget: true)?.FullName ?? file;
        File.Copy(resolved, destFile, overwrite: true);
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
