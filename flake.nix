{
  description = "My first minimal flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs";  # Use unstable channel instead of release

    # Home manager
    home-manager.url = "github:nix-community/home-manager"; 
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; 

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware"; 

    neovim-flake = {
      url = "github:jordanisaa/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    }
 
    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [ ./nixos/configuration.nix ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "stablejoy@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [ ./home-manager/home.nix ];
      };
    };
  };
}
