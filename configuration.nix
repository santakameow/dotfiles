{
    modulesPath,
    lib,
    pkgs,
    ...
} @ args:
{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        (modulesPath + "/profiles/qemu-guest.nix")
        ./disk-config.nix
    ];
    boot.loader.grub = {
        # no need to set devices, disko will add all devices that have a EF02 partition to the list already
        # devices = [ ];
        efiSupport = true;
        efiInstallAsRemovable = true;
    };

    disko.devices.disk.main.device = "/dev/vda";

    # workaround for vps
    networking.useDHCP = false;
    networking.useNetworkd = true;

    systemd.network.networks."10-ens3" = {
        matchConfig.Name = "ens3";
        address = [
            "152.234.245.97/32"
            "2a12:bec4:1b50:aae::2/64"
        ];
        routes = [
            { Destination = "0.0.0.0/0"; Gateway = "172.16.0.1"; GatewayOnLink = true; }
            { Destination = "::/0"; Gateway = "2a12:bec4:1b50:aae::1"; }
        ];
    };
    networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

    services.openssh.enable = true;

    environment.systemPackages = map lib.lowPrio [
        pkgs.curl
        pkgs.gitMinimal
    ];

    users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdlcjFtISF+IZ8I6+G48VcpsaCbTNpdzX7TfX+MIrPe"
    ] ++ (args.extraPublicKeys or []); # this is used for unit-testing this module and can be removed if not needed

  system.stateVersion = "24.05";
}
