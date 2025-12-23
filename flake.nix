{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration.nix
            ./qemu-guest-hardware.nix
            inputs.nix-index-database.nixosModules.default
            inputs.nur.modules.nixos.default
          ];
        };
        fujitsu = nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration.nix
            ./fujitsu-hardware.nix
            inputs.nix-index-database.nixosModules.default
            inputs.nur.modules.nixos.default
          ];
        };
      };
    };
}
