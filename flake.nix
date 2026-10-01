{
  description = "Gaddafi is back";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

  outputs = {nixpkgs, ...}: {
    nixosConfigurations.gaddafi = nixpkgs.lib.nixosSystem {
      modules = [./nixos/configuration.nix];
    };
  };
}
