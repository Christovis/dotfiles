#!/bin/bash
############################
# This script creates symlinks from the home directory to
# any desired dotfiles in ~/.dotfiles
#
# Operation System:
#    - Manjaro
# Terminal Emulator:
#    - Konsole (default for Manjaro GNOME)
# Requirements:
#    - wmctrl
#    - nvm, zsh, tmux, zsh, zplug
#    - neovim: Python 3, Node.js
#
# Inspired by https://github.com/iamrecursion/dotfiles
############################

# Current linux window manager (e.g. Gnome, i3)
wm=""

# Functions
wm_gnome="gnome"
wm_i3="i3"

# Backup Existing Files
backup_dir="${HOME}/dotfilesbackup"
update_dir="${HOME}/.dotfiles"
system_deps=""

# Script Configuration
status_prefix="INFO >>";


# -----------------------------------------------------------------------------
detect_wm () {
# identify the window manager that is used
    if [[ $(wmctrl -m) =~ 'GNOME' ]]; then
        read -p "Do you want to create environment for the GNOME window manager?" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            wm=${wm_gnome}
        else
            read -p "What environment do you want to create? i3 or Gnome" -n 1 -r
            echo
            if [[ "$REPLY" =~ i3 ]]; then
                wm=${wm_i3}
            else
                wm=${wm_gnome}
            fi
        fi
    elif [[ $(wmctrl -m) =~ 'i3' ]]; then
        read -p "Do you want to create environment for the i3 window manager?" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            wm=${wm_i3}
        else
            read -p "What environment do you want to create? i3 or Gnome" -n 1 -r
            echo
            if [[ "$REPLY" =~ i3 ]]; then
                wm=${wm_i3}
            else
                wm=${wm_gnome}
            fi
        fi
    fi
}


confirm() {
    local prompt default reply pdefault
    prompt="${1}"

    if [ "${2:-}" = "Y" ]; then
        pdefault="Y/n"
        default=Y
    elif [ "${2:-}" = "N" ]; then
        pdefault="y/N"
        default=N
    else
        pdefault="y/n"
        default=
    fi

    while true; do

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "${prompt} [${pdefault}] "

        # Read the answer (use /dev/tty in case stdin is redirected from
        # somewhere else)
        read -r reply </dev/tty

        # Default?
        [ -z "${reply// }" ] && reply=${default}

        # Check if the reply is valid
        case "${reply}" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}


confirm_string() {
    local prompt default reply pdefault
    prompt="${1}"
    default="${2}"

    # Default?
    [[ -n "${default// }" ]] && pdefault=" [${default}]" || pdefault=""

    # Ask the question
    read -r -p "${prompt}${pdefault} " reply

    # Empty reply?
    echo "${reply:-$default}"
}


install_system_package() {
    [[ -z "${*// }" ]] && return 0

error= << ERR
"Installing system packages currently not compatible with your package manager.
ERR

    if [[ "${wm}" == "${wm_gnome}" ]] ; then
        if [ -n "$(command -v yay)" ]; then
            yay -Syu && yay -S ${@}
        elif [ -n "$(command -v pacman)" ]; then
            sudo pacman -Syu && sudo pacman -S ${@}
        elif [ -n "$(command -v apt-get)" ]; then
            sudo apt-get update -qq && sudo apt-get install ${@} -y
        else
            >&2 echo $error
            return 1
        fi
    else
        >&2 echo "Unknown window manager"
        return 1
    fi
}


preinstall () {
# installs dependent git repos (mostly for zsh functionalities)
cat << STATUS
============================ SETTING UP ENVIRONMENT ===========================
STATUS

    # Cloning Submodules
    echo "${status_prefix} Cloning Submodules"

    cd ${DIR};
    git submodule update --init --recursive;
    cd ${HOME};
}


link_zsh () {
    echo "${status_prefix} Linking ZSH Configuration"

    ln -sf ${DIR}/zsh/zshrc ${HOME}/.zshrc

    return 0
}


link_termite () {
    echo "${status_prefix} Linking Termite Configuration"

    ln -sf ${DIR}/termite/config ${HOME}/.config/termite/config

    return 0
}


link_neovim () {
    # initialise settings
    echo "${status_prefix} Linking Neovim Configuration"
    nvimrc_dir="${HOME}/.config/nvim"
    nvim_plugs_dir="${HOME}/.local/share/nvim/plugged"

    # create directory
    if [ ! -d  "${nvimrc_dir}" ]; then
        echo "${status_prefix} Creating "${nvimrc_dir}" for Nvim \
            configuration";
        mkdir -p "${nvimrc_dir}"
    fi

    if [ ! -d "${nvim_plugs_dir}" ]; then
        echo "${status_prefix} Creating "${nvim_plugs_dir}" for plugins";
        mkdir -p "${nvim_plugs_dir}"
    fi

    # create symlinks
    ln -sf "${DIR}/nvim/init.vim" "${nvimrc_dir}/init.vim"
    ln -sf "${DIR}/nvim/coc-settings.json" "${nvimrc_dir}/coc-settings.json"

    #if [ ! -e "${nvim_plugs_dir}/autoload" ]; then
    #    ln -sf "${DIR}/nvim/autoload" "${nvim_plugs_dir}/autoload"
    #fi

    # set up npm for CoC code completion (needs to be installed after zsh set-up)
    # npm install -g neovim
    return 0
}


link_ergodox () {
    echo "${status_prefix} Linking ErgoDox-EZ configuration"
    # Based on the following instructions:
    #   - https://github.com/zsa/wally/wiki/Linux-install
    #   - https://github.com/zsa/wally/wiki/Live-training-on-Linux

    ln -sf "${DIR}/ergodox/50-oryx.rules" "/etc/udev/rules.d/50-oryx.rules"

    # Make sure your user is part of the plugdev group
    # (as it is not the default on some distros):
    sudo pacman -S gtk3 webkit2gtk libusb
    sudo groupadd plugdev
    sudo usermod -aG plugdev $USER

    return 0
}

link_pop_shell () {
    echo "${status_prefix} Setting up Pop_shell"
    // https://github.com/pop-os/shell

    git clone https://github.com/pop-os/shell.git
    cd shell
    sh rebuild.sh
}


link_i3 () {
    echo "${status_prefix} Linking i3 configuration"
    # Based on the following instructions:
    #   - https://github.com/Airblader/i3/wiki/installation
    #   - https://github.com/polybar/polybar

    # Make sure your user is part of the plugdev group
    # (as it is not the default on some distros):
    sudo pacman -S i3-gaps polybar compton-conf

    i3_dir="${HOME}/.i3/"
    polybar_dir="${HOME}/.config/polybar/"
    mkdir -p "${i3_dir}"
    mkdir -p "${polybar_dir}"

    ln -sf "${DIR}/i3/i3.conf" "${i3_dir}/conf"
    ln -sf "${DIR}/i3/i3blocks.conf" "${i3_dir}/i3blocks.conf"
    ln -sf "${DIR}/polybar/battery.py" "${polybar_dir}battery.py"
    ln -sf "${DIR}/polybar/bluetooth.sh" "${polybar_dir}bluetooth.sh"
    ln -sf "${DIR}/polybar/config" "${polybar_dir}config"
    ln -sf "${DIR}/polybar/launch.sh" "${polybar_dir}launch.sh"
    ln -sf "${DIR}/polybar/mpris.sh" "${polybar_dir}mpris.sh"
    ln -sf "${DIR}/polybar/musicWorkspaceSwitcher.sh" "${polybar_dir}musicWorkspaceSwitcher.sh"
    ln -sf "${DIR}/polybar/pavolume.sh" "${polybar_dir}pavolume.sh"
    ln -sf "${DIR}/polybar/playpause.sh" "${polybar_dir}playpause.sh"
    ln -sf "${DIR}/polybar/redshift.sh" "${polybar_dir}redshift.sh"
    ln -sf "${DIR}/i3/compton.conf" "${HOME}/.config/compton.conf"

    return 0
}

link_tmux () {
    echo "${status_prefix} Linking Tmux configuration"

    ln -sf "${DIR}/tmux/tmux.conf" "${HOME}/.tmux.conf"

    return 0
}


link_gdb () {
    echo "${status_prefix} Linking GDB Configuration"

    ln -sf "${DIR}/tools/gdbinit" "${HOME}/.gdbinit"

    return 0
}


create_gitconfig () {
    target_file="${HOME}/.gitconfig"

    confirm "Create gitconfig?" || return 0

    echo "${status_prefix} Creating Git Configuration"

    cp "${DIR}/git/gitconfig" "${target_file}"

    if [[ ${wm} == "${wm_gnome}" ]]; then
        response=$(confirm_string "Enter git user.name" "$(git config --get user.name)")
        sed -i "s/##git_name##/${response}/g" ${target_file}

        response=$(confirm_string "Enter git user.email" "$(git config --get user.email)")
        sed -i "s/##git_email##/${response}/g" ${target_file}

        response=$(confirm_string "Enter git user.signingkey" "$(git config --get user.email)")
        sed -i "s/##git_signingkey##/${response}/g" ${target_file}
    else
        echo "Unknown window manager ${wm}. Cannot execute sed."
    fi

    # Global Gitignore
    ignore_source_file="${DIR}/git/gitignore_global"
    ignore_target_file="${HOME}/.gitignore_global"

    ln -sf ${ignore_source_file} ${ignore_target_file}

    return 0
}


install () {
    #link_i3 || exit 1
    #link_zsh || exit 1
    link_neovim || exit 1
    #link_termite || exit 1
    #link_ergodox || exit 1
    #link_tmux || exit 1
    #link_gdb || exit 1
    #if [[ ${wm} == "${wm_i3}" ]]; then
    #	    link_polybar || exit 1
    #fi

    create_gitconfig || exit 1
}


postinstall () {
    echo "${status_prefix} Rewriting Master URL to Use SSH"

    cd ${DIR} > /dev/null || return;
    git remote set-url origin git@github.com:Christovis/dotfiles.git;
    cd ${HOME} > /dev/null || return;

cat << EOM
================================= PLEASE READ =================================
If using TMUX, please start it and execute 'C-a' + 'I' to install plugins.
If using zsh, please source '~/.zshrc' and execute 'zplug install'.
If using nvim or vim, please open the respective editor and run ':PlugInstall'
to install the plugin configuration. This step will likely require system
dependencies for the various plugins. These include:
  - rustc
  - ghc
  - stack
For IDE functionality in neovim, you will likely need to install the various
language servers. These are listed in \`nvim/init.vim\` in the section entitled
'Coc.nvim Configuration'. Nvim will still work without these installed, but none
of the IDE functionality will be available.
EOM
}


# -----------------------------------------------------------------------------
# Main

main () {
    # Getting Script Directory
    SOURCE="${BASH_SOURCE[0]}"

    while [ -h "${SOURCE}" ]; do # resolve $SOURCE until file no longer a link
      DIR="$( cd -P "$( dirname "${SOURCE}" )" >/dev/null 2>&1 && pwd )"
      SOURCE="$(readlink "${SOURCE}")"
      [[ ${SOURCE} != /* ]] && SOURCE="${DIR}/${SOURCE}" # resolve rel symlinks
    done

    DIR="$( cd -P "$( dirname "${SOURCE}" )" >/dev/null 2>&1 && pwd )"

    # Install Setup
    detect_wm || exit 1
    confirm "Install dotfiles for ${wm} window manager?"|| exit
    install_system_package "${system_deps}" || exit 1

    # Installs
    #preinstall
    install
    #postinstall  # Copy and Edit Gitconfig
}

# -----------------------------------------------------------------------------
# Run

if (( ${BASH_VERSION%%.*} < 4 )) ; then
    >&2 echo "Requires bash version 4.0.0 or higher, you've got ${BASH_VERSION} in /bin/bash"
    >&2 echo "You may have a newer version elsewhere. Use it to run this script directly."
    exit 1
fi

main
