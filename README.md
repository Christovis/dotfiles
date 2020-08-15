<p align="center">
   <img src="https://github.com/Christovis/dotfiles/blob/master/dotfiles-logo-stacked.png" alt="dotfiles stacked logo" width="100">
</p>

This repo contains my dotfiles. It provides default configuration for the set of
applications that I use day-to-day.

It currently supports:
- **OS**: Manjaro
- DE: Gnome (+ Pop_Shell), i3 (+ extentions)
- **Terminal**: Konsole, Termite

and configures
- `git`: A sensible gitconfig where user name, email and GPG key can be set at
  install time, as well as a sensible global gitignore. The gitconfig is set up
  to work with this gitignore. [-]
- `neovim`: configurations for fluid editing of vim with comprehensive IDE features for C++, Python, Scala, and a some other languages. [-]
- `tmux`: A configuration that tries makes using tmux intuitive, and also allows
  for seamless interoperation with Neovim. [-]
- `zsh`: A configurations including a custom theme with a _useful_ prompt clock. [-]
- `termite`:  highly customizable terminal emulator
- `polybar`:  highly customizable status bars for their desktop environmen. [i3]
- `ergodox-ez`:  highly customizable keyboard

## Installation
This repo comes with a simple install script that eases the installation process
and makes getting set up on a new machine fairly simple. As a prerequisite, you
will need the above listed programs installed to make use of the configuration.

1. Clone the repository into `~/.dotfiles`. The install script isn't precious
   about this location, but some of the configuration relies on it.

   ```
   git clone https://github.com/iamrecursion/dotfiles ~/.dotfiles
   ```
2. Execute the install script. You may need to explicitly tell it which bash to
   use if you fail the compatibility check (common on MacOS).

   ```
   ~/.dotfiles/install.sh
   ```

3. When prompted, enter your name, email and GPG key for git.
4. Follow the final setup instructions printed to the terminal.

Most files will be symlinked from the repo, though some will be copied into
their final locations.

NB: This will overwrite any existing configuration that exists at the target
paths, so if you want to try these out please back up your configuration.

## Credits
Thanks to [Ara Adkins](https://github.com/iamrecursion) for the inspiration and [Joel Glovier](https://github.com/jglovier) for the [Dofiles Logo](https://github.com/jglovier/dotfiles-log\o).
