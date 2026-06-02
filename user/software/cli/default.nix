{ lib, ... }: {
  imports = (import ../../../lib { inherit lib; }).importDir ./.;
}
