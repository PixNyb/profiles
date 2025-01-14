autoload -U colors && colors

if [ -d "$HOME" ]; then
    [[ -r ~/.zshrc ]] && . ~/.zshrc
    [[ -f ~/.zsh_aliases ]] && . ~/.zsh_aliases

    if [[ -f ~/.config/color ]]; then
        COLOR=$(cat ~/.config/color)
    else
        colors=("red" "green" "blue" "yellow" "cyan" "magenta")
        COLOR=${colors[$RANDOM % ${#colors[@]}]}
        echo $COLOR >~/.config/color
    fi
else
    colors=("red" "green" "blue" "yellow" "cyan" "magenta")
    COLOR=${colors[$RANDOM % ${#colors[@]}]}
fi

# Check if the terminal supports colors
if [[ $TERM == *"color"* ]]; then
    SUPPORTS_COLORS=true
else
    SUPPORTS_COLORS=false
fi

precmd() {
    LAST_RESULT=$?
    COLOR_SUPPORT=$(tput colors 2>/dev/null || echo 8)

    if [[ $COLOR_SUPPORT -lt 8 ]] || [[ $TERM != *"xterm"* && $TERM != *"screen"* && $TERM != *"color"* ]] || [[ -n $NO_COLOR ]]; then
        PROMPT='('$LAST_RESULT') %m - %n - %~ %# '
        return
    fi

    if [[ $LAST_RESULT -ne 0 ]]; then
        LAST_RESULT_COLOR="red"
    else
        LAST_RESULT_COLOR="gray"
    fi

    if $SUPPORTS_COLORS; then
        if sudo -n true 2>/dev/null; then
            PROMPT='%F{8}(%B%F{'$LAST_RESULT_COLOR'}'$LAST_RESULT'%b%F{8}) %F{'$COLOR'}%m %F{8}- %B%F{'$COLOR'}%n%b %F{8}- %F{8}%~%b %B%F{red}%#%b %f'
        else
            PROMPT='%F{8}(%B%F{'$LAST_RESULT_COLOR'}'$LAST_RESULT'%b%F{8}) %F{'$COLOR'}%m %F{8}- %B%F{'$COLOR'}%n%b %F{8}- %F{8}%~%b %F{8}%# %f'
        fi
    else
        PROMPT='('$LAST_RESULT') %m - %n - %~ %'
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd
