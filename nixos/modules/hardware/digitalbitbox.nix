{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.digitalbitbox;
in

{
  options.hardware.digitalbitbox = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables udev rules for Digitalbitbox devices.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.digitalbitbox ];
  };
}
