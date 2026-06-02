{ lib }: {
  # Import all *.nix files in a directory, excluding default.nix.
  importDir = dir:
    map (name: dir + "/${name}")
      (builtins.attrNames
        (lib.filterAttrs
          (name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
          (builtins.readDir dir)));
}
