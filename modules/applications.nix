{ pkgs, config, lib, ... }:
with config.deviceSpecific;
{
  options = with lib;
    with types; {
      defaultApplications = mkOption {
        type = attrsOf (submodule ({ name, ... }: {
          options = {
            cmd = mkOption { type = path; };
            desktop = mkOption { type = str; };
          };
        }));
        description = "Preferred applications";
      };

      startupApplications = mkOption {
        type = listOf path;
        description = "Applications to run on startup";
      };
    };
  config = rec {
    defaultApplications = {
      pdf = {
        cmd = "${pkgs.zathura}/bin/zathura";
        desktop = "zathura";
      };
    };
  };
}
