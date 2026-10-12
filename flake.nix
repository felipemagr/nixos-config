{
  description = "Gaddafi is back";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

  outputs = {nixpkgs, ...}: {
    nixosConfigurations.gaddafi = nixpkgs.lib.nixosSystem {
      modules = [./nixos/configuration.nix];
    };
  };
}
