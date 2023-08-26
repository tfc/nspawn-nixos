# nspawn-nixos

This repository contains nix recipes of NixOS images that can be run on any
GNU/Linux that has `systemd` using `machinectl`.

## How to run this

Two steps:


```sh
machinectl pull-tar https://...
machinectl start nixos

# Set root password
machinectl shell nixos /usr/bin/env passwd

machinectl login nixos
```

You can also change the configuration in this repository first, and then import
a local build:

```sh
machinectl import-tar $(nix build --print-out-paths)/tarball/* nixos
```

If you want the container to use the host's network, create a configuration
file like this:

```sh
printf "[Network]\nVirtualEthernet=no" > /etc/systemd/nspawn/nixos.nspawn
```

The system configuration in `/etc/nixos/configuration.nix` can be adapted to
your needs.
`nixos-rebuild switch` activates a new configuration.

If you would like to share mounts between host and container, create port
mappings, etc. please refer to the
[`systemd.nspawn` config file documentation](https://man7.org/linux/man-pages/man5/systemd.nspawn.5.html)
and/or the [archlinux wiki about `systemd-nspawn`](https://wiki.archlinux.org/title/systemd-nspawn)

## Why not Docker images?

Docker puts the file system of any Linux distro around a single process, but it
essentially does not run a whole system.
Running NixOS (or any other distro) in `systemd-nspawn` is similar to running a
full VM, but with the same thin namespace isolation as in Docker, which leads to
less overhead.

Changes that you do to your nspawn container remain persistent by default.
