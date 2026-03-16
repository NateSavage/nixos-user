set windows-shell := ["pwsh", "-NoLogo", "-NonInteractive", "-Command"]

default:
    @just --list

# On a windows machine, copies dotfiles into repo, commits and pushes them.
# Run from Cmder, PowerShell, or any Windows terminal.
# To add folders, edit scripts/dotfiles-update-windows.ps1
dotfiles-update-windows:
    pwsh -File scripts/dotfiles-update-windows.ps1
