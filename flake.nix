{
  description = "my flake for my server!!!!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs }: {
    nixosConfigurations = {
      sash = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	specialArgs = { inherit inputs; };
	modules = [
	  ./sash.nix
	  ./hardware-configuration.nix
	];
      };
    };
  };
}
