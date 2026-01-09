{
  description = "my flake for my server!!!!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      mountGdrive = pkgs.writeShellScriptBin "mount-gdrive" ''
        if [ ! -d "/home/ash/gdrive" ]; then
          mkdir -p /home/ash/gdrive
        fi

        ${pkgs.rclone}/bin/rclone mount gdrive: /home/ash/gdrive \
          --vfs-cache-mode writes \
          --daemon
      '';

      umountGdrive = pkgs.writeShellScriptBin "umount-gdrive" ''
        fusermount -u /home/ash/gdrive
      '';
    in
    {
      nixosConfigurations = {
        sash = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./sash.nix
            ./hardware-configuration.nix
          ];
        };
      };

      apps.${system} = {
        mount-gdrive = {
          type = "app";
          program = "${mountGdrive}/bin/mount-gdrive";
        };

        umount-gdrive = {
          type = "app";
          program = "${umountGdrive}/bin/umount-gdrive";
        };

        default = self.apps.${system}.mount-gdrive;
      };
    };
}
