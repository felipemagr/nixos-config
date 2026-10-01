<div align="center">

# nixos-config

Declarative NixOS configuration for my home server.

[![NixOS](https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=white)](https://nixos.org)
[![Nix Flakes](https://img.shields.io/badge/Nix-flakes-7EBAE4?logo=snowflake&logoColor=white)](https://nixos.wiki/wiki/Flakes)

</div>

## Structure

```
flake.nix      entry point and pinned inputs
nixos/         one module per concern, imported by configuration.nix
```

## Usage

```bash
# Validate
nix flake check

# Apply on the host
sudo nixos-rebuild switch --flake .#<host>

# Apply remotely
nixos-rebuild switch --flake .#<host> --target-host <user>@<host> --use-remote-sudo

# Update inputs
nix flake update
```
