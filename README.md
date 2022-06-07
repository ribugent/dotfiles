# Gerard Ribugent - Dotfiles

>_There's no place like 🏡_

This repository contains all the dotfiles I use on my work computer.

All the files are managed using [chezmoi](https://www.chezmoi.io/), but the secrets and sensitive information are stored using [pass](https://www.passwordstore.org/)

## Prerequisites

- [chezmoi](https://www.chezmoi.io/)
- [pass](https://www.passwordstore.org/)
- [gnupg](https://gnupg.org/)
- [git](https://git-scm.com/)
- [yay](https://github.com/Jguer/yay) (Arch Linux only)
- base-devel[\[1\]](https://archlinux.org/groups/x86_64/base-devel/)[\[2\]](https://archlinux.org/groups/any/base-devel/) packages (Arch Linux only)
- My gpg keys 🙈

## Bootstrapping

0. Install needed software
1. Import my gpg keys
2. Clone password store

    ```sh
    git@github.com:ribugent/$SECRETS.git ~/.password-store
    ```

3. Create `~/.config/chezmoi/chezmoi.toml` and fill it with the information

    ```toml
    [data.git]
    name = ...

    [data.git.work]
    email = ...
    signkey = ...

    [data.git.personal]
    email = ...
    signkey = ...
    ```

4. Finally apply

    ```sh
    chezmoi init --apply git@github.com:ribugent/dotfiles.git
    ```

## Included configuration

### Arch Linux

Installing automatically packages and optional package dependencies using [yay](https://github.com/Jguer/yay), the lists can be found in [1](arch-config/packages.txt) and [2](arch-config/packages-optional.txt).

Some drop in configuration system files are installed using `makepkg`:

- SDDM
  - Enable HiDPI in wayland
  - Disable listening http connections in xorg
  - Plasma Desktop settings
- Kernel parameters
  - Hardening
    - Restrict `dmesg` to root only
    - Disable `kexec` syscall
    - Restrict pointers in proc filesystem
  - Set swappiness to 20
- ~~[Reflector](https://wiki.archlinux.org/title/reflector): Options for selecting the mirrors~~
- Systemd resolved
  - Disables default DNS servers
  - Set DNSSEC with allow downgrade
  - Enable stub listener to be integrated with Docker (this solve issues DNS resolutions with custom domains on VPN connections)
- xorg: Enforce 1080p resolution on my Dell XPS 13 laptop with 4k screen

### Fish

Drop-in files for `$PATH` management:

- [jenv](https://www.jenv.be/)
- [nvm](https://github.com/nvm-sh/nvm)
- [plenv](https://github.com/tokuhirom/plenv)
- [pyenv](https://github.com/pyenv/pyenv)
- `~/.local/bin`

Set some default env variables in order to:

- Disable ugly GTK+ options
- Enforce GTK+ app to use Plasma Desktop file dialogs
- Default(terminal) editor to `vim`
- Set `$BROWSER` to use `xdg-open`

Currently I'm using [oh-my-fish](https://github.com/oh-my-fish/oh-my-fish). The repo includes:

- Installs it automatically
- Trigger install when the packages list is updated
- Sets my favourite theme

### Git

- Setups globally my work information
- Setup specific dirs to use my personal information
- Enables company git hooks software only in specific dir
- Enables verbose doing commits
- Customize diff tool
- Customize colours
- `main` as a default branch on init

### GnuPG

Set `pinentry-qt` as the default pinentry program.

### Gradle

Disable ram consuming gradle daemon... I have 16GB of RAM, but it's not enough sometimes.

### Ssh

Basic ssh configuration with known host and rendering work sensitive hosts from the secret store using a template.

### Yay (Arch Linux only)

Setups system java, perl and python versions to avoid issues when building packages.
