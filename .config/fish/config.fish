# Environment
set -gx EDITOR nvim

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
