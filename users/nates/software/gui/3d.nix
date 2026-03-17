{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    unstable.blender
    unstable.plasticity
  ];
}
