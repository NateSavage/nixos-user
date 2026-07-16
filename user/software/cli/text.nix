{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    stable.micro
    # neovim itself is built in nvim.nix (wrapped with precompiled
    # treesitter grammars on packpath)
  ];
}
