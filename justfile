set windows-shell := ["pwsh", "-NoLogo", "-NonInteractive", "-Command"]

default:
    @just --list

# Copies dotfiles into repo, commits and pushes them.
dotfiles-save:
    dotnet run ./scripts/dotfiles-save.cs

# Restores dotfiles from repo. Pass username if not running as the target user (Linux only).
dotfiles-load username="":
    dotnet run ./scripts/dotfiles-load.cs -- {{username}}
