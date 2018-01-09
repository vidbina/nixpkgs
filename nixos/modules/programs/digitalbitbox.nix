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
        Installs the Digital Bitbox application and enables the complementary hardware module.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.digitalbitbox ];
    hardware.digitalbitbox.enable = true;
  };
}
