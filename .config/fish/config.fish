source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# abbreviations
abbr -a g git
abbr -a v nvim
abbr -a vim nvim
abbr -a uvmanage 'uv run manage.py'
abbr -a nx 'nix develop --command fish'
abbr -a z zellij
function sc
    sesh connect (sesh list -t -c | fzf --header "Select session")
end

# opencode
fish_add_path $HOME/.opencode/bin
direnv hook fish | source
