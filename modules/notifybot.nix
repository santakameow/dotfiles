{ pkgs, config, sakanotifybot, ... }:
let
    domain = "bot.sakanai.space";
    webhookPath = "/tg/notifybot/webhook";
    listenAddr = "127.0.0.1:8080";
    bot = sakanotifybot.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
        # Upstream hardcodes the path for both URL validation and request routing.
        postPatch = (old.postPatch or "") + ''
            substituteInPlace webhook.go main.go \
                --replace-fail '/telegram/webhook' '${webhookPath}'
        '';
    });
in
{
    age.secrets.notifybot.file = ../secrets/notifybot.age;

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.caddy = {
        enable = true;
        virtualHosts.${domain} = {
            # Do not log the Telegram webhook secret header.
            logFormat = null;
            extraConfig = ''
                handle ${webhookPath} {
                    reverse_proxy ${listenAddr}
                }
                handle {
                    respond 404
                }
            '';
        };
    };

    systemd.services.sakanotifybot = {
        description = "Sakanotifybot Telegram reminders";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" "caddy.service" ];
        after = [ "network-online.target" "caddy.service" ];

        environment = {
            BOT_LISTEN_ADDR = listenAddr;
            BOT_DATA_FILE = "/var/lib/sakanotifybot/state.json";
        };

        serviceConfig = {
            ExecStart = "${bot}/bin/sakanotifybot";
            EnvironmentFile = config.age.secrets.notifybot.path;
            DynamicUser = true;
            StateDirectory = "sakanotifybot";
            StateDirectoryMode = "0700";
            WorkingDirectory = "/var/lib/sakanotifybot";
            Restart = "on-failure";
            RestartSec = "15s";
        };
    };
}
