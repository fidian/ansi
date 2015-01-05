#!/bin/bash
#
# ANSI code generator
#
# © Copyright 2015 Tyler Akins
# Licensed under the MIT license with an additional non-advertising clause
# See http://github.com/fidian/ansi

add-code() {
    local N

    if [[ "$1" == *=* ]]; then
        N="${1#*=}"
        N="${N//,/;}"
    else
        N=""
    fi

    OUTPUT="$OUTPUT$CSI$N$2"
}

add-color() {
    OUTPUT="$OUTPUT$CSI${1}m"

    if [ ! -z "$2" ]; then
        SUFFIX="$CSI${2}m$SUFFIX"
    fi
}

color-table() {
    local FNB_LOWER FNB_UPPER PADDED

    FNB_LOWER="$(colorize 2 22 f)n$(colorize 1 22 b)"
    FNB_UPPER="$(colorize 2 22 F)N$(colorize 1 22 B)"
    echo -n "bold $(colorize 1 22 Sample)               "
    echo -n "faint $(colorize 2 22 Sample)              "
    echo "italic $(colorize 3 23 Sample)"
    echo -n "underline $(colorize 4 24 Sample)          "
    echo -n "blink $(colorize 5 25 Sample)              "
    echo "inverse $(colorize 7 27 Sample)"
    echo "invisible $(colorize 8 28 Sample)"
    echo -n "strike $(colorize 9 29 Sample)             "
    echo -n "fraktur $(colorize 20 23 Sample)            "
    echo "double-underline $(colorize 21 24 Sample)"
    echo -n "frame $(colorize 51 54 Sample)              "
    echo -n "encircle $(colorize 52 54 Sample)           "
    echo "overline $(colorize 53 55 Sample)"
    echo ""
    echo "             black   red     green   yellow  blue    magenta cyan    white"
    for BG in 40:black 41:red 42:green 43:yellow 44:blue 45:magenta 46:cyan 47:white; do
        PADDED="bg-${BG:3}           "
        PADDED="${PADDED:0:13}"
        echo -n "$PADDED"
        for FG in 30 31 32 33 34 35 36 37; do
            echo -n "$CSI${BG:0:2};${FG}m"
            echo -n "$FNB_LOWER"
            echo -n "$CSI$(( $FG + 60 ))m"
            echo -n "$FNB_UPPER"
            echo -n "${CSI}0m  "
        done
        echo ""
        echo -n "  +intense   "
        for FG in 30 31 32 33 34 35 36 37; do
            echo -n "$CSI$(( ${BG:0:2} + 60 ));${FG}m"
            echo -n "$FNB_LOWER"
            echo -n "$CSI$(( $FG + 60 ))m"
            echo -n "$FNB_UPPER"
            echo -n "${CSI}0m  "
        done
        echo ""
    done
    echo ""
    echo "Legend:"
    echo "    Normal color:  f = faint, n = normal, b = bold."
    echo "    Intense color:  F = faint, N = normal, B = bold."
}

colorize() {
    echo -n "$CSI${1}m$3$CSI${2}m"
}

is-ansi-supported() {
    # Idea:  CSI c
    # Response = CSI ? 6 [234] ; 2 2 c
    # The "22" means ANSI color
    echo "can't tell yet"
}

report() {
    local BUFF C

    REPORT=""
    echo -n "$CSI$1"
    read -r -N ${#2} -s -t 1 BUFF

    if [ "$BUFF" != "$2" ]; then
        return 1
    fi

    read -r -N ${#3} -s -t 1 BUFF

    while [ "$BUFF" != "$3" ]; do
        REPORT="$REPORT${BUFF:0:1}"
        read -r -N 1 -s -t 1 C || exit 1
        BUFF="${BUFF:1}$C"
    done
}

show-help() {
    cat <<EOF
Generate ANSI escape codes

Please keep in mind that your terminal must support the code in order for you
to see the effect properly.

Usage
    ansi [OPTIONS] [TEXT TO OUTPUT]

Option processing stops at the first unknown option or at "--".  Options
are applied in order as specified on the command line.  Unless --no-restore
is used, the options are unapplied in reverse order, restoring your
terminal to normal.

Optional parameters are surrounded in brackets and use reasonable defaults.
For instance, using --down will move the cursor down one line and --down=10
moves the cursor down 10 lines.

Display Manipulation
    --insert-chars[=N], --ich[=N]
                             Insert blanks at cursor, shifting the line right.
    --erase-display[=N], --ed[=N]
                             Erase in display. 0=below, 1=above, 2=all,
                             3=saved.
    --erase-line[=N], --el[=N]
                             Erase in line. 0=right, 1=left, 2=all.
    --insert-lines[=N], --il[=N]
    --delete-lines[=N], --dl[=N]
    --delete-chars[=N], --dch[=N]
    --scroll-up[=N], --su[=N]
    --scroll-down[=N], --sd[=N]
    --erase-chars[=N], --ech[=N]
    --repeat[=N], --rep[=N]  Repeat preceding character N times.

Cursor:
    --up[=N], --cuu[=N]
    --down[=N], --cud[=N]
    --forward[=N], --cuf[=N]
    --backward[=N], --cub[=N]
    --next-line[=N], --cnl[=N]
    --prev-line[=N], --cpl[=N]
    --column[=N], --cha[=N]
    --position[=[ROW],[COL]], --cup[=[ROW],[=COL]]
    --tab-forward[=N]        Move forward N tab stops.
    --tab-backward[=N]       Move backward N tab stops.
    --column-relative[=N], --hpr[=N]
    --line[=N], --vpa[=N]
    --line-relative[=N], --vpr[=N]
    --save-cursor            Saves the cursor position.  Restores the cursor
                             after writing text to the terminal unless
                             --no-restore is also used.
    --restore-cursor         Just restores the cursor.
    --hide-cursor            Will automatically show cursor unless --no-restore
                             is also used.
    --show-cursor

Colors:
    Attributes:
        --bold, --faint, --italic, --underline, --blink, --inverse,
        --invisible, --strike, --fraktur, --double-underline, --frame,
        --encircle, --overline
    Foreground:
        --black, --red, --green, --yellow, --blue, --magenta, --cyan, --white,
        --black-intense, --red-intense, --green-intense, --yellow-intense,
        --blue-intense, --magenta-intense, --cyan-intense, --white-intense
    Background:
        --bg-black, --bg-red, --bg-green, --bg-yellow, --bg-blue,
        --bg-magenta, --bg-cyan, --bg-white, --bg-black-intense,
        --bg-red-intense, --bg-green-intense, --bg-yellow-intense,
        --bg-blue-intense, --bg-magenta-intense, --bg-cyan-intense,
        --bg-white-intense
    Reset:
        --reset-attrib       Removes bold, italics, etc.
        --reset-foreground   Sets foreground to default color.
        --reset-background   Sets background to default color.
        --reset-color        Resets attributes, foreground, background.

Report:
    ** NOTE:  These require reading from stdin.  Results are sent to stdout.
    ** If no response from terminal in 1 second, these commands fail.
    --report-position        ROW,COL
    --report-window-state    "open" or "iconified"
    --report-window-position X,Y
    --report-window-pixels   HEIGHT,WIDTH
    --report-window-chars    ROWS,COLS
    --report-screen-chars    ROWS,COLS of the entire screen
    --report-icon
    --report-title

Miscellaneous:
    --color-table            Display a color table.
    --icon=NAME              Set the terminal's icon name.
    --title=TITLE            Set the terminal's window title.
    --no-restore             Do not issue reset codes when changing colors.
                             For example, if you change the color to green,
                             normally the color is restored to default
                             afterwards.  With this flag, the color will
                             stay green even when the command finishes.
    -n, --newline            Add a newline at the end.
    --escape                 Allow text passed in to contain escape sequences.
    --reset                  Reset colors, clear screen, show cursor, move
                             cursor to 1,1.
EOF
}

# Handle long options until we hit an unrecognized thing
CONTINUE=true
RESTORE=true
NEWLINE=false
ESCAPE=false
ESC="$(echo -e '\033')"
CSI="${ESC}["
OSC="${ESC}]"
ST="${ESC}\\"
OUTPUT=""
SUFFIX=""
while $CONTINUE; do
    case "$1" in
        --help | -h | -\?)
            show-help
            ;;

        # Display Manipulation
        --insert-chars | --insert-chars=* | --ich | --ich=*)
            add-code "$1" @
            ;;

        --erase-display | --erase-display=* | --ed | --ed=*)
            add-code "$1" J
            ;;

        --erase-line | --erase-line=* | --el | --el=*)
            add-code "$1" K
            ;;

        --insert-lines | --insert-lines=* | --il | --il=*)
            add-code "$1" L
            ;;

        --delete-lines | --delete-lines=* | --dl | --dl=*)
            add-code "$1" M
            ;;

        --delete-chars | --delete-chars=* | --dch | --dch=*)
            add-code "$1" P
            ;;

        --scroll-up | --scroll-up=* | --su | --su=*)
            add-code "$1" S
            ;;

        --scroll-down | --scroll-down=* | --sd | --sd=*)
            add-code "$1" T
            ;;

        --erase-chars | --erase-chars=* | --ech | --ech=*)
            add-code "$1" X
            ;;

        --repeat | --repeat=* | --rep | --rep=N)
            add-code "$1" b
            ;;

        # Cursor Positioning
        --up | --up=* | --cuu | --cuu=*)
            add-code "$1" A
            ;;

        --down | --down=* | --cud | --cud=*)
            add-code "$1" B
            ;;

        --forward | --forward=* | --cuf | --cuf=*)
            add-code "$1" C
            ;;

        --backward | --backward=*| --cub | --cub=*)
            add-code "$1" D
            ;;

        --next-line | --next-line=* | --cnl | --cnl=*)
            add-code "$1" E
            ;;

        --prev-line | --prev-line=* | --cpl | --cpl=*)
            add-code "$1" F
            ;;

        --column | --column=* | --cha | --cha=*)
            add-code "$1" G
            ;;

        --position | --position=* | --cup | --cup=*)
            add-code "$1" H
            ;;

        --tab-forward | --tab-forward=* | --cht | --cht=*)
            add-code "$1" I
            ;;

        --tab-backward | --tab-backward=* | --cbt | --cbt=*)
            add-code "$1" Z
            ;;

        --column-relative | --column-relative=* | --hpr | --hpr=*)
            add-code "$1" 'a'
            ;;

        --line | --line=* | --vpa | --vpa=*)
            add-code "$1" 'd'
            ;;

        --line-relative | --line-relative=* | --vpr | --vpr=*)
            add-code "$1" 'e'
            ;;

        --save-cursor)
            OUTPUT="$OUTPUT${CSI}s"
            SUFFIX="${CSI}u$SUFFIX"
            ;;

        --restore-cursor)
            OUTPUT="$OUTPUT${CSI}u"
            ;;

        --hide-cursor)
            OUTPUT="$OUTPUT${CSI}?25l"
            SUFFIX="${CSI}?25h"
            ;;

        --show-cursor)
            OUTPUT="$OUTPUT${CSI}?25h"
            ;;

        # Colors - Attributes
        --bold)
            add-color 1 22
            ;;

        --faint)
            add-color 2 22
            ;;

        --italic)
            add-color 3 23
            ;;

        --underline)
            add-color 4 24
            ;;

        --blink)
            add-color 5 25
            ;;

        --inverse)
            add-color 7 27
            ;;

        --invisible)
            add-color 8 28
            ;;

        --strike)
            add-color 9 20
            ;;

        --fraktur)
            add-color 20 23
            ;;

        --double-underline)
            add-color 21 24
            ;;

        --frame)
            add-color 51 54
            ;;

        --encircle)
            add-color 52 54
            ;;

        --overline)
            add-color 53 55
            ;;

        # Colors - Foreground
        --black)
            add-color 30 39
            ;;

        --red)
            add-color 31 39
            ;;

        --green)
            add-color 32 39
            ;;

        --yellow)
            add-color 33 39
            ;;

        --blue)
            add-color 34 39
            ;;

        --magenta)
            add-color 35 39
            ;;

        --cyan)
            add-color 36 39
            ;;

        --white)
            add-color 37 39
            ;;

        --black-intense)
            add-color 90 39
            ;;

        --red-intense)
            add-color 91 39
            ;;

        --green-intense)
            add-color 92 39
            ;;

        --yellow-intense)
            add-color 93 39
            ;;

        --blue-intense)
            add-color 94 39
            ;;

        --magenta-intense)
            add-color 95 39
            ;;

        --cyan-intense)
            add-color 96 39
            ;;

        --white-intense)
            add-color 97 39
            ;;

        # Colors - Background
        --bg-black)
            add-color 40 49
            ;;

        --bg-red)
            add-color 41 49
            ;;

        --bg-green)
            add-color 42 49
            ;;

        --bg-yellow)
            add-color 43 49
            ;;

        --bg-blue)
            add-color 44 49
            ;;

        --bg-magenta)
            add-color 45 49
            ;;

        --bg-cyan)
            add-color 46 49
            ;;

        --bg-white)
            add-color 47 49
            ;;

        --bg-black-intense)
            add-color 100 49
            ;;

        --bg-red-intense)
            add-color 101 49
            ;;

        --bg-green-intense)
            add-color 102 49
            ;;

        --bg-yellow-intense)
            add-color 103 49
            ;;

        --bg-blue-intense)
            add-color 104 49
            ;;

        --bg-magenta-intense)
            add-color 105 49
            ;;

        --bg-cyan-intense)
            add-color 106 49
            ;;

        --bg-white-intense)
            add-color 107 49
            ;;

        # Colors - Reset
        --reset-attrib)
            OUTPUT="$OUTPUT${CSI}22;23;24;25;27;28;29;54;55m"
            ;;

        --reset-foreground)
            OUTPUT="$OUTPUT${CSI}39m"
            ;;

        --reset-background)
            OUTPUT="$OUTPUT${CSI}39m"
            ;;

        --reset-color)
            OUTPUT="$OUTPUT${CSI}0m"
            ;;

        # Reporting
        --report-position)
            report 6n "$CSI" R || exit 1
            echo "${REPORT//;/,}"
            ;;

        --report-window-state)
            report 11t "$CSI" t || exit 1
            case "$REPORT" in
                1)
                    echo "open"
                    ;;

                2)
                    echo "iconified"
                    ;;

                *)
                    echo "unknown ($REPORT)"
                    ;;
            esac
            ;;

        --report-window-position)
            report 13t "${CSI}3;" t || exit 1
            echo "${REPORT//;/,}"
            ;;

        --report-window-pixels)
            report 14t "${CSI}4;" t || exit 1
            echo "${REPORT//;/,}"
            ;;

        --report-window-chars)
            report 18t "${CSI}8;" t || exit 1
            echo "${REPORT//;/,}"
            ;;

        --report-screen-chars)
            report 19t "${CSI}9;" t || exit 1
            echo "${REPORT//;/,}"
            ;;

        --report-icon)
            report 20t "${OSC}L" "$ST" || exit 1
            echo "${REPORT}"
            ;;

        --report-title)
            report 21t "${OSC}l" "$ST" || exit 1
            echo "${REPORT}"
            ;;

        # Miscellaneous
        --color-table)
            color-table
            ;;

        --icon=*)
            OUTPUT="$OUTPUT${OSC}1;${1#*=}$ST"
            ;;

        --title=*)
            OUTPUT="$OUTPUT${OSC}2;${1#*=}$ST"
            ;;

        --no-restore)
            RESTORE=false
            ;;

        -n | --newline)
            NEWLINE=true
            ;;

        --escape)
            ESCAPE=true
            ;;

        --reset)
            # 0m - reset all colors and attributes
            # 2J - clear terminal
            # 1;1H - move to 1,1
            # ?25h - show cursor
            OUTPUT="$OUTPUT${CSI}0m${CSI}2J${CSI}1;1H${CSI}?25h"
            ;;

        --)
            CONTINUE=false
            shift
            ;;

        *)
            CONTINUE=false
            ;;
    esac

    if $CONTINUE; then
        shift
    fi
done

echo -n "$OUTPUT"

if $ESCAPE; then
    echo -en "${1+"$@"}"
else
    echo -n "${1+"$@"}"
fi

if $RESTORE; then
    echo -n "$SUFFIX"
fi

if $NEWLINE; then
    echo ""
fi
