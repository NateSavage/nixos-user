$folders = @{
    "$env:APPDATA\Zed"       = "dotfiles\.config\zed"
    "$env:LOCALAPPDATA\nvim" = "dotfiles\.config\nvim"
}

foreach ($srcFolder in $folders.Keys) {
    $dst = $folders[$srcFolder]
    Remove-Item -Recurse -Force $dst -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force $dst | Out-Null
    Get-ChildItem -Path $srcFolder | Copy-Item -Destination $dst -Recurse -Force
}

git reset HEAD
git add dotfiles/
git commit -m "Updated Dotfiles"
git push
