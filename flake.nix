{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        disko.url = "github:nix-community/disko";
        disko.inputs.nixpkgs.follows = "nixpkgs";
        nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
        sakanotifybot.url = "github:santakameow/sakanotifybot";
        sakanotifybot.inputs.nixpkgs.follows = "nixpkgs";
        agenix.url = "github:ryantm/agenix";
        agenix.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = {
        self,
        nixpkgs,
        disko,
        nixos-facter-modules,
        sakanotifybot,
        agenix,
        ...
    }: {
      # nixos-facter (https://github.com/numtide/nixos-facter)
      # nixos-anywhere --flake .#freya --generate-hardware-config nixos-facter facter.json <hostname>
        nixosConfigurations.freya = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit sakanotifybot; };
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
                agenix.nixosModules.default
            ];
        };
    };
}
