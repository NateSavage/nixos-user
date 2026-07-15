{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    stable.ion
  ];
    
  users.users.nates.shell = pkgs.stable.ion;
}
