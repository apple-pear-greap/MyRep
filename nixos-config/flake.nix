{
  description = "NixOS 配置 - 数学与统计学专业学习环境";

  inputs = {
    # 使用 NixOS 23.11 稳定版以确保可靠性
    # Using NixOS 23.11 stable for reliability; update to 24.05 or later when ready
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # 替换 "your-hostname" 为你的实际主机名
      your-hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.student = import ./home.nix;
          }
        ];
      };
    };
  };
}
