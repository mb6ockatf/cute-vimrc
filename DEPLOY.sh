#!/usr/bin/env bash
declare -A dot_files
dot_files[alacritty.yml]="$HOME/.alacritty.yml"
dot_files[bashrc]="$HOME/.bashrc"
dot_files[vscode_argv.json]="$HOME/.config/Code/User/settings.json"
dot_files[vimrc]="$HOME/.vim/vimrc"
dot_files[bspwmrc]="$HOME/.config/bspwm/bspwmrc"
dot_files[sxhkdrc]="$HOME/.config/sxhkd/sxhkdrc"
dot_files[neofetch.conf]="$HOME/.config/neofetch/config.conf"
dot_files[polybar/launch.sh]="$HOME/.config/polybar/launch.sh"
dot_files[polybar/config.ini]="$HOME/.config/polybar/config.ini"
declare -a dot_folders
dot_folders[1]="$HOME/.vim"
dot_folders[2]="$HOME/.config/Code/User"
dot_folders[3]="$HOME/.config/bspwm"
dot_folders[4]="$HOME/.config/sxhkd"
dot_folders[5]="$HOME/.config/neofetch"
dot_folders[6]="$HOME/.config/polybar"

###############################################################################
# repeat character $1 $2 times
# arguments: $1 character, $2 number
# output: $2 characters
###############################################################################
repeat_char() { for ((i = 1; i < $2; i++)); do echo -n "$1"; done }

###############################################################################
# print usage help
# no arguments required
# output: help prompt
###############################################################################
usage() {
	local name="${BASH_SOURCE[-1]}"
	cat << end_of_message
Process your configuration files
USAGE
- show this message (default)
	$name [-h, --help]
- pack  your configuration files to project folder
	$name pack
- install your configuration files to system
	$name install
$(repeat_char - 80)
mb6ockatf, Sat 01 Jul 2023 01:19:20 PM MSK
end_of_message
}

###############################################################################
# collect all configuration files and pack into this folder
###############################################################################
collect_configuration() {
	for folder in "${dot_folders[@]}"; do mkdir -v -p "$folder"; done
	for file in "${!dot_files[@]}"; do cp -vu $"${dot_files[$file]}" "$file"
	done
}

###############################################################################
# move all configuration files from this folder to their paths
###############################################################################
install_configuration() {
	for folder in "${!dot_folders[@]}"; do mkdir -v -p "${dot_folders[$folder]}"
	done
	for file in "${!dot_files[@]}"; do cp -vu "$file" "${dot_files[$file]}"
	done
}

###############################################################################
# install system packages with pacman
# arguments: $1 - program name
###############################################################################
pacman_install() { sudo pacman -S --needed "$1"; }

###############################################################################
# pretty print message with gum
# arguments: $1 - message
# output: gum formatted message
###############################################################################
pprint() {
	local message
	message=$(gum style --border normal --border-foreground 3 "$1")
	echo "$message"
}
echo "${BASH_SOURCE[*]}"
case $1 in
	pack | --pack | -p ) collect_configuration ;;
	install | --install | -i ) install_configuration ;;
	help | --help | -h) usage ;;
	depends )
		echo "running system upgrade" && sudo pacman -Syuu
		echo "installing gum" && pacman_install gum
		pprint "installing pyenv" && pacman_install pyenv ;;
	*) echo "no mode value provided"; usage ;;
esac
echo
unset filename foldername usage dot_files dot_folders
exit