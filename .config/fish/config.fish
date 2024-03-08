if status is-interactive
    # Commands to run in interactive sessions can go here
end

zoxide init fish | source


function fzf
	command fzf --preview 'bat --color=always {}' --preview-window '~3'
end

function ll
	command lsd -la
end

