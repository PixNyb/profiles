autoload -U colors && colors

[[ -r ~/.zshrc ]] && . ~/.zshrc
[[ -f ~/.zsh_aliases ]] && . ~/.zsh_aliases

if [[ -f ~/.config/color ]]; then
    COLOR=$(cat ~/.config/color)
else
    colors=("red" "green" "blue" "yellow" "cyan" "magenta")
    COLOR=${colors[$RANDOM % ${#colors[@]}]}
    echo $COLOR >~/.config/color
fi

# Check if the terminal supports colors
if [[ $TERM == *"color"* ]]; then
    SUPPORTS_COLORS=true
else
    SUPPORTS_COLORS=false
fi

precmd() {
    LAST_RESULT=$?
    COLOR_SUPPORT=$(tput colors)

    if [[ $COLOR_SUPPORT -lt 8 ]] || [[ -n $NO_COLOR ]]; then
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
            PROMPT='%F{black}(%B%F{'$LAST_RESULT_COLOR'}'$LAST_RESULT'%b%F{black}) %F{'$COLOR'}%m %F{black}- %B%F{'$COLOR'}%n%b %F{black}- %F{black}%~%b %B%F{red}%#%b %f'
        else
            PROMPT='%F{black}(%B%F{'$LAST_RESULT_COLOR'}'$LAST_RESULT'%b%F{black}) %F{'$COLOR'}%m %F{black}- %B%F{'$COLOR'}%n%b %F{black}- %F{black}%~%b %F{black}%# %f'
        fi
    else
        if sudo -n true 2>/dev/null; then
            PROMPT='('$LAST_RESULT') %m - %n - %~ %#'
        else
            PROMPT='('$LAST_RESULT') %m - %n - %~ %'
        fi
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd
