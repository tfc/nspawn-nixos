{ pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    ./nspawn-image.nix
  ];

  boot.isContainer = true;
  networking.hostName = "nixos";

  # activate Nix Flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  system.stateVersion = "23.11";

  # Set an initial password here or at runtime do `machinectl shell nixos` and
  # run `passwd` there.
  # users.users.root.initialHashedPassword = "";
}
