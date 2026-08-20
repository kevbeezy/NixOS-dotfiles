# For More Information - https://wiki.archlinux.org/title/Fish

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

function opencode
    /usr/bin/bash -c '/home/joachim/.opencode/bin/opencode "$@"' -- $argv
end

if status is-interactive
# Commands to run in interactive sessions can go here
    command clear
    fastfetch
	zoxide init fish | source
end

starship init fish | source
set -gx EDITOR nvim
set -gx VISUAL nvim
