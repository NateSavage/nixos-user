{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    stable.ion
    stable.starship
  ];
    
  users.users.nates.shell = pkgs.stable.ion;
}
