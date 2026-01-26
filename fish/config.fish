if status is-interactive
    # --- Settings ---
    set -g fish_greeting ""
    # --- Yazi Function ---
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        command yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    # --- Key Bindings ---
    function fish_user_key_bindings
        # Ctrl+G to launch Yazi
        bind \cg 'y; commandline -f repaint'
        # Ctrl+Backspace to delete word
        bind \b backward-kill-word
				#bind \x7f backward-kill-word
    end

		# prevent ssh from restarting again and agani
if not pgrep -u $USER ssh-agent > /dev/null
    ssh-agent -c > ~/.ssh/agent.env
end
if test -z "$SSH_AUTH_SOCK"
    source ~/.ssh/agent.env > /dev/null
end


set -gx EDITOR nvim
set -gx VISUAL nvim

#command to clean up directory
alias cleanup='sudo pacman -Rns (pacman -Qdtq); sudo paccache -r; sudo journalctl --vacuum-time=3d'
# tmux with conf
		alias -s tmux='tmux -f ~/.config/tmux/tmux.conf'
    # --- Aliases ---
    alias ls='ls --color=auto'
    alias v='nvim'
end
