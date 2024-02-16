# Gerard Ribugent - Dotfiles

>_There's no place like 🏡_

This repository contains all the dotfiles I use on my work computer, which currently supports Arch Linux and macOS

All the files are managed using [chezmoi](https://www.chezmoi.io/), but the secrets and sensitive information are stored using [pass](https://www.passwordstore.org/)

## Prerequisites

- All OSes:

  - [chezmoi](https://www.chezmoi.io/)
  - [pass](https://www.passwordstore.org/)
  - [gnupg](https://gnupg.org/)
  - [git](https://git-scm.com/)
  - [git-delta](https://github.com/dandavison/delta)
  - My gpg keys 🙈

- Arch Linux:
  - [yay](https://github.com/Jguer/yay) (Arch Linux only)
  - [base-devel](https://archlinux.org/packages/core/any/base-devel/)
  - User sudo enabled

- macOS:

  - [Brew](https://brew.sh)


## Bootstrapping

0. Install needed software
1. Import my gpg keys
2. Clone password store

    ```sh
    git@github.com:ribugent/$SECRETS.git ~/.password-store
    ```

3. Create `~/.config/chezmoi/chezmoi.toml` and fill it with the information

    ```toml
    [diff]
    command = "delta"
    args = ["--pager=never"]

    [data.git]
    name = "<your name>"

    [data.git.work]
    email = "<work email>"
    signkey = "<work gpg sign key>"
    remotePrefix = "<work git remote prefix>"

    [data.git.personal]
    email = "<personal email>"
    signkey = "<personal gpg sign key>"
    remotePrefix = "<personal git remote prefix>"

    [date.noisetorch]
    device_unit = "<microphone device unit>"
    device_name = "<microphone device name>"
    ```

4. Finally apply

    ```sh
    chezmoi init --apply git@github.com:ribugent/dotfiles.git
    ```

## Included configuration

### Fish shell

Drop-in files for `$PATH` management:

- [jenv](https://www.jenv.be/)
- [nodenv](https://github.com/nodenv/nodenv)
- [plenv](https://github.com/tokuhirom/plenv)
- [pyenv](https://github.com/pyenv/pyenv)
- `~/.local/bin`

Set some default env variables in order to:

- (Linux only) Disable ugly GTK+ options
- (Linux only) Default(terminal) editor to `vim`
- (Linux only) Set `$BROWSER` to use `xdg-open`
- Enable colors on man pages
- Aliases
  - `cat` for [`bat -pp`](https://github.com/sharkdp/bat)
  - `cz` for `chezmoi`
  - `df` for [`duf`](https://github.com/muesli/duf)

Currently, I'm using [oh-my-fish](https://github.com/oh-my-fish/oh-my-fish). The repo includes:

- Installs it automatically
- Trigger install when the packages list is updated
- Sets my favorite theme


### Git

- Setups globally my work information
- Setup specific dirs to use my personal information
- Enables company git hooks software only in specific dir
- Enables verbose doing commits
- Customize diff tool
- Customize colours
- `main` as a default branch on init
- Use [gitdelta](https://github.com/dandavison/delta) as (terminal) diff viewer
- Use [git-interactive-rebase-tool](https://github.com/MitMaro/git-interactive-rebase-tool) as interactive rebase tool

### GnuPG

Set `pinentry-qt` as the default pinentry program in Linux and set `$GPG_TTY` environment variable to allow pinentry-curses working in macOS.

### Gradle

Disable ram consuming gradle daemon... I have 16GB of RAM, but it's not enough sometimes.

### Jenv

*ℹ️ Linux Only*

Automatically register and refresh jdk versions using systemd user units

- [jenv-refresh.path](https://github.com/ribugent/dotfiles/blob/main/private_dot_config/systemd/user/jenv-refresh.path)
- [jenv-refresh.service](https://github.com/ribugent/dotfiles/blob/main/private_dot_config/systemd/user/jenv-refresh.service)

### Ssh

Basic ssh configuration with known hosts and rendering work sensitive hosts from the secret store using a [template](https://github.com/ribugent/dotfiles/blob/main/.chezmoitemplates/ssh_config_host).

### Arch Linux system

*ℹ️ Arch Linux Only*

Installing automatically packages and optional package dependencies using [yay](https://github.com/Jguer/yay), the lists can be found in [\[1\]](https://github.com/ribugent/dotfiles/blob/main/archlinux/packages.txt) and [\[2\]](https://github.com/ribugent/dotfiles/blob/main/archlinux/packages-optional.txt).

Some drop-in configuration system files are installed using `makepkg`:

- SDDM
  - Enable HiDPI in Wayland
  - Disable listening tcp connections in xorg
  - Plasma Desktop settings
- Kernel parameters
  - Hardening
    - Restrict `dmesg` to root only
    - Disable `kexec` syscall
    - Restrict pointers in proc filesystem
  - Set swappiness to 20
- [Reflector](https://wiki.archlinux.org/title/reflector): Options for selecting the mirrors
- Faillock: block accounts after 5 consecutive authentication failures
- Systemd resolved
  - Disables default DNS servers
  - Enable stub listener to be integrated with Docker (this solve issues DNS resolutions with custom domains on VPN connections)
- xorg: Enforce 1080p resolution on my Dell XPS 13 laptop with 4k screen

### macOS system

*ℹ️ macOS Only*

- Installing automatically packages from a [Brewfile](https://github.com/ribugent/dotfiles/blob/main/macos/Brewfile)
- GNU coreutils and recent version of curl in `$PATH`
- Fix keybindings for Home/End keys using a regular keyboard
- Quarantine bit auto-removal from few specific apps
- Setup qtpass to find out git and gpg utlities from brew
- Enable uptimed and locate services
- Enable fingerprint for sudo

### ClamAV

*ℹ️ Linux Only*

- Installs ClamAV
- Enables update signatures services
- Tune up the daemon configuration
- ~~Set up daily scanning and reporting via notification~~

### Firewalld

*ℹ️ Linux Only*

Enable the firewalld by default, and [integrate the docker interface](https://docs.docker.com/network/iptables/#integration-with-firewalld) to the specified zone.

### Yakuake

*ℹ️ Linux Only*

Set up dropdown terminal with Fira Code nerdfonts

### iTerm2

*ℹ️ macOS Only*

Set up dropdown terminal with Fira Code nerdfonts

### Yay

*ℹ️ Linux Only*

Setup system java, perl and python versions to avoid issues when building packages.
Third-party account settings

### Third-party services setup

- Increase AWS S3 concurrent requests
- Docker registries
- npm private registry
- Databricks service


# Password store structure
For those who want to reuse these dotfiles, this requires the following structure:

```
Password Store
├── aws
│   ├── accountId -> password
│   └── region    -> password
├── databricks
│   ├── prod    -> password(api key), fields(host)
│   └── staging -> password(api key), fields(host)
├── docker
│   ├── dockerRegistry -> password(token)
│   └── githubRegistry -> password(token)
├── npm
│   └── github -> password(token)
└── ssh
    ├── hosts -> raw(json array equivalent of ssh regular config, see how is rendered in .chezmoitemplates/ssh_config_host )
    └── keys
        ├── arch-aur -> raw(ssh key)
        ├── github   -> raw(ssh key)
        └── work     -> raw(ssh key)
```

Every entry details how is stored the info, as password, password with fields or just raw; in brackets some clarifications are specified.
