{ lib, pkgs, ... }:

{
  # Installing a new system within the nspawn means that the /sbin/init script
  # just needs to be updated, as there is no bootloader.

  system.build.installBootLoader = pkgs.writeScript "install-sbin-init.sh" ''
    #!${pkgs.runtimeShell}
    ln -fs "$1/init" /sbin/init
  '';

  system.activationScripts.installInitScript = lib.mkForce ''
    ln -fs $systemConfig/init /sbin/init
  '';
}
