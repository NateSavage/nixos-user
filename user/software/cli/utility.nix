{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    stable.yazi
    stable.diskonaut
    stable.fzf        # find files fuzzy (ff)
    stable.livegrep   # find words in file (fw)
  ];

}
