if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
    starship init fish | source
end
export PATH="$HOME/.local/bin:$PATH"

# opencode
fish_add_path /home/bao_desktop/.opencode/bin
