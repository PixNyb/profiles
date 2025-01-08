set -U colors red green blue yellow cyan magenta white
set -U fish_greeting ''

if test -f ~/.config/color
    set COLOR (cat ~/.config/color)
else
    set -l colors red green blue yellow cyan magenta
    set COLOR $colors[(math (random) % (count $colors) + 1)]
    echo $COLOR > ~/.config/color
end

function fish_prompt
    set -l LAST_RESULT $status
    set -l COLOR_SUPPORT (tput colors)

    if test $COLOR_SUPPORT -lt 8; or set -q NO_COLOR
        echo '('$LAST_RESULT') '(hostname)' - '(whoami)' - '$PWD' > '
        return
    end

    if test $LAST_RESULT -ne 0
        set LAST_RESULT (set_color --bold red)$LAST_RESULT(set_color normal)
    else
        set LAST_RESULT (set_color --bold white)$LAST_RESULT(set_color normal)
    end

    set -l RELATIVE_PATH (string replace -r "^$HOME" "~" $PWD)

    if sudo -n true 2>/dev/null
        echo (set_color black)'('$LAST_RESULT(set_color black)') '(set_color $COLOR)(hostname) (set_color black)'- '(set_color --bold $COLOR)(whoami)(set_color normal) (set_color black)'- '(set_color black)$RELATIVE_PATH (set_color --bold red)'> '(set_color normal)
    else
        echo (set_color black)'('$LAST_RESULT(set_color black)') '(set_color $COLOR)(hostname) (set_color black)'- '(set_color --bold $COLOR)(whoami)(set_color normal) (set_color black)'- '(set_color black)$RELATIVE_PATH (set_color black)'> '(set_color normal)
    end
end