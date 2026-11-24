# Environment
set -gx EDITOR nvim
set -gx NIX_DAEMON_SOCKET_PATH /var/nix/daemon-socket/socket

# User executables
fish_add_path ~/.local/bin ~/.bun/bin ~/go/bin

if status is-interactive
    # Disable the startup greeting
    set -g fish_greeting

    zoxide init fish | source

    starship init fish | source

    fzf --fish | source

    alias cd='z'

    probe-rs complete install
end
