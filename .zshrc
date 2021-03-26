### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

### Zplugins
# Remember to make the last plugin loaded in turbo mode have atload'zpcompinit' for
# completion support, this will make plugin loading super snappy!

### Functions to make zinit configuration less verbose
zpt() { zinit ice wait"${1}" lucid               "${@:2}"; } # Turbo
zpi() { zinit ice lucid                            "${@}"; } # Regular Ice
zp()  { [ -z $2 ] && zinit light $@ || zinit $@; } # zinit

### Oh-my-zsh libs
zinit snippet OMZ::plugins/chruby/chruby.plugin.zsh
zinit snippet OMZ::plugins/cloudfoundry/cloudfoundry.plugin.zsh
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZ::plugins/jenv/jenv.plugin.zsh
zinit snippet OMZ::plugins/npm/npm.plugin.zsh
zinit snippet OMZ::plugins/nvm/nvm.plugin.zsh

setopt promptsubst

# Prompt
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

# Syntax Highlighting
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# For GNU ls (the binaries can be gls, gdircolors, e.g. on OS X when installing the
# coreutils package from Homebrew; you can also use https://github.com/ogham/exa)
zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

# exa
zinit ice as"program" from"gh-r" mv"exa* -> exa"
zinit light ogham/exa

# Path to dotfiles repo
export DOTFILES="$(dirname "$(readlink "$HOME/.zshrc")")"

# Find all zsh files
configs=($DOTFILES/zsh/*.zsh)
for file in "${configs[@]}"
do
  source "$file"
done

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes
