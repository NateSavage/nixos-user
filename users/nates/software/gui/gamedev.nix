{ pkgs, ... }: {
  users.users.nates.packages = with pkgs; [
    unstable.godot_4
    unstable.godot_4-export-templates-bin
    unstable.unityhub
  ];
}
