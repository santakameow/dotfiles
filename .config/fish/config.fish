if status is-interactive
    # Commands to run in interactive sessions can go here
    
    # things for development
    source "$HOME/.cargo/env.fish"

    # starship
    starship init fish | source

    # zoxide
    zoxide init fish | source
    alias cd="z"

    # yazi
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        command yazi $argv --cwd-file="$tmp"
        if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    # some useful aliases
    alias :q="exit"
    alias lgit="lazygit"
    alias vim="nvim"
    alias vi="nvim"
    alias ff="fastfetch"

    # environment
    set -gx EDITOR nvim
    set -g fish_greeting
end
