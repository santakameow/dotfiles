{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        disko.url = "github:nix-community/disko";
        disko.inputs.nixpkgs.follows = "nixpkgs";
        nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    };

    outputs = {
        nixpkgs,
        disko,
        nixos-facter-modules,
        ...
    }: {
      # nixos-facter (https://github.com/numtide/nixos-facter)
      # nixos-anywhere --flake .#freya --generate-hardware-config nixos-facter facter.json <hostname>
        nixosConfigurations.freya = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                disko.nixosModules.disko
                ./configuration.nix
                nixos-facter-modules.nixosModules.facter
                {
                    config.facter.reportPath =
                        if builtins.pathExists ./facter.json then
                            ./facter.json
                        else
                            throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
                }
            ];
        };
    };
}
