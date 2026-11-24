{
    # workaround for networking in vps
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


    services.qemuGuest.enable = true;
}
