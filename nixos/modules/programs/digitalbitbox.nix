{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.digitalbitbox;
in

{
  options.programs.digitalbitbox = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Installs the Digitalbitbox application and enables the udev rules for the hardware.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.digitalbitbox ];
    hardware.digitalbitbox.enable = true;
  };
}
