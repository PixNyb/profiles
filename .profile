if [ -d "$HOME" ]; then
    if [ -f ~/.config/color ]; then
        COLOR=$(cat ~/.config/color)
    else
        colors="red green blue yellow cyan magenta"
        set -- $colors
        COLOR=$(eval echo \${$((RANDOM % $# + 1))})
        echo $COLOR >~/.config/color
    fi
else
    colors="red green blue yellow cyan magenta"
    set -- $colors
    COLOR=$(eval echo \${$((RANDOM % $# + 1))})
fi

get_color() {
    case $1 in
    red)
        echo "31"
        ;;
    green)
        echo "32"
        ;;
    yellow)
        echo "33"
        ;;
    blue)
        echo "34"
        ;;
    magenta)
        echo "35"
        ;;
    cyan)
        echo "36"
        ;;
    *)
        echo "31"
        ;;
    esac
}

set_prompt() {
    LAST_RESULT=$?
    COLOR_SUPPORT=$(tput colors 2>/dev/null || echo 8)

    if [ $COLOR_SUPPORT -lt 8 ] || [[ $TERM != *"xterm"* && $TERM != *"screen"* && $TERM != *"color"* ]] || [ -n "$NO_COLOR" ]; then
        PS1="($LAST_RESULT) \h - \u - $PWD $ "
        return
    fi

    if [ $LAST_RESULT -ne 0 ]; then
        LAST_RESULT_COLOR=$(get_color red)
    else
        LAST_RESULT_COLOR=37
    fi

    RELATIVE_PATH="$PWD"
    if [[ $RELATIVE_PATH == $HOME* ]]; then
        RELATIVE_PATH="~${RELATIVE_PATH#$HOME}"
    fi

    if sudo -n true 2>/dev/null; then
        PS1='\[\e[30m\](\[\e[1;'"$LAST_RESULT_COLOR"'m\]'"$LAST_RESULT"'\[\e[0;30m\]) \[\e[0;'"$(get_color $COLOR)"'m\]\h \[\e[30m\]- \[\e[1;'"$(get_color $COLOR)"'m\]\u\[\e[0;30m\] - \[\e[30m\]'"$RELATIVE_PATH"' \[\e[1;'"$(get_color red)"'m\]\$\[\e[0m\] '
    else
        PS1='\[\e[30m\](\[\e[1;'"$LAST_RESULT_COLOR"'m\]'"$LAST_RESULT"'\[\e[0;30m\]) \[\e[0;'"$(get_color $COLOR)"'m\]\h \[\e[30m\]- \[\e[1;'"$(get_color $COLOR)"'m\]\u\[\e[0;30m\] - \[\e[30m\]'"$RELATIVE_PATH"' \[\e[30m\]\$\[\e[0m\] '
    fi
}

PROMPT_COMMAND=set_prompt
