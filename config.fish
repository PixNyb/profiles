set -U colors red green blue yellow cyan magenta white brblack
set -U fish_greeting ''

if test -d $HOME
    if test -f ~/.config/color
        set COLOR (cat ~/.config/color)
    else
        set -l colors red green blue yellow cyan magenta
        set COLOR $colors[(math (random) % (count $colors) + 1)]
        echo $COLOR > ~/.config/color
    end
else
    set -l colors red green blue yellow cyan magenta
    set COLOR $colors[(math (random) % (count $colors) + 1)]
end

function fish_prompt
    set -l LAST_RESULT $status
    set -l COLOR_SUPPORT (tput colors 2>/dev/null; or echo 8)
    set -l RELATIVE_PATH (string replace -r "^$HOME" "~" $PWD)

    if test $COLOR_SUPPORT -lt 8
        or not string match -qr 'xterm' -- $TERM
        and not string match -qr 'screen' -- $TERM
        or test -n "$NO_COLOR"
        echo '('$LAST_RESULT') '(hostname)' - '(whoami)' - '$RELATIVE_PATH' > '
        return
    end

    if test $LAST_RESULT -ne 0
        set LAST_RESULT (set_color --bold red)$LAST_RESULT(set_color normal)
    else
        set LAST_RESULT (set_color --bold white)$LAST_RESULT(set_color normal)
    end

    if sudo -n true 2>/dev/null
        echo (set_color brblack)'('$LAST_RESULT(set_color brblack)') '(set_color $COLOR)(hostname) (set_color brblack)'- '(set_color --bold $COLOR)(whoami)(set_color normal) (set_color brblack)'- '(set_color brblack)$RELATIVE_PATH (set_color --bold red)'> '(set_color normal)
    else
        echo (set_color brblack)'('$LAST_RESULT(set_color brblack)') '(set_color $COLOR)(hostname) (set_color brblack)'- '(set_color --bold $COLOR)(whoami)(set_color normal) (set_color brblack)'- '(set_color brblack)$RELATIVE_PATH (set_color brblack)'> '(set_color normal)
    end
end
