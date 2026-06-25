{
  description = ''
    For questions just DM me on X: https://twitter.com/@m3tam3re
    There is also some NIXOS content on my YT channel: https://www.youtube.com/@m3tam3re

    One of the best ways to learn NIXOS is to read other peoples configurations. I have personally learned a lot from Gabriel Fontes configs:
    https://github.com/Misterio77/nix-starter-configs
    https://github.com/Misterio77/nix-config

    Please also check out the starter configs mentioned above.
  '';

  inputs = {
    # packages
    master.url = "github:nixos/nixpkgs/master";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.11";

    # hardware
    hardware.url = "github:NixOS/nixos-hardware/master";

    # secerets
    agenix.url = "github:ryantm/agenix";

    # user
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "git+https://github.com/4ry1337/dotfiles.git";
      flake = false;
    };
    tpm = {
      url = "github:tmux-plugins/tpm";
      flake = false;
    };
    darkmatter.url = "gitlab:VandalByte/darkmatter-grub-theme";

    # desktop
    hyprswitch.url = "github:H3rmt/hyprswitch";
  };

  outputs =
    {
      self,
      home-manager,
      hardware,
      dotfiles,
      agenix,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        blind-warrior = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            hardware.nixosModules.lenovo-legion-y530-15ich
            agenix.nixosModules.default
            inputs.darkmatter.nixosModule
            ./hosts/blind-warrior
          ];
        };
      };
      homeConfigurations = {
        "rakhat@blind-warrior" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/rakhat/blind-warrior.nix ];
        };
      };
    };
}
