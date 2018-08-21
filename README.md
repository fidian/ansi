ANSI Code Generator
===================

![](images/headline.png)

This bash script will generate the proper ANSI escape sequences to move the cursor around the screen, make text bold, add colors and do much more.  It is designed to help you colorize words and bits of text.

If it helps, you can think of it as a curses / ncurses library for bash, or a tool that helps you using tricks from DOS's ANSI.SYS.  Or you might consider this to be your magic highlighter that has always been missing from bash.


Installation
------------

Download `ansi` and put it somewhere in your path.  Make sure that it is executable (`chmod a+x ansi` works well).  Bash will need to be present, but it is often installed by default.  No external commands are used; this only uses bash's built-in features.

    # Download
    curl -OL git.io/ansi

    # Make executable
    chmod 755 ansi

    # Copy to somewhere in your path
    sudo mv ansi /usr/local/bin/

Not all features will work with all terminals.  Your terminal determines if particular codes work.


Upgrading Issues
----------------

The newer version of `ansi` has reversed an earlier decision about newlines at the end.  Previously, calling `ansi test` would write "test" to the screen without a newline and `ansi -n test" would add a newline. As of August 2018, this has switched and `ansi test` will write out "test" with a newline. The `-n` flag is also switched. Sorry for the inconvenience that the earlier decision has caused and future confusion due to this flag switching. The goal is to align more closely with `echo`.


Usage
-----

    ansi [OPTIONS] [TEXT TO DISPLAY]

The OPTIONS are numerous and are detailed below.  You can specify as many as you like.  Option processing stops at the first unknown option and at `--`.  Options are applied in the order specified on the command line.  Colors are reset and attributes are restored to default unless `--no-restore` is used.


Examples
--------

Here's a few quick examples to get you started.

    # Write "Tests pass" in green on its own line
    ansi --green --newline "Tests pass"

    # Change the terminal's title to the working directory
    ansi --title="$(pwd)"

    # Reset the terminal colors and move the cursor to row 1 column 1
    # and show the cursor if it was previously hidden.
    # This is the same as the --reset option.
    ansi --erase-display=2 --reset-all --position=1,1 --show-cursor

    # Find out how many lines the terminal can display
    ansi --report-window-chars | cut -d , -f 1

Need more?  Check out the [examples/](examples/) folder.


Options - Display Manipulation
------------------------------

The short version of these options comes from the command they are implementing.

* `--insert-chars[=N]`, `--ich[=N]` - Insert blanks at cursor, shifting the line right.
* `--erase-display[=N]`, `--ed[=N]` - Erase in display. 0=below, 1=above, 2=all, 3=saved.
* `--erase-line[=N]`, `--el[=N]` - Erase in line. 0=right, 1=left, 2=all.
* `--insert-lines[=N]`, `--il[=N]`
* `--delete-lines[=N]`, `--dl[=N]`
* `--delete-chars[=N]`, `--dch[=N]`
* `--scroll-up[=N]`, `--su[=N]`
* `--scroll-down[=N]`, `--sd[=N]`
* `--erase-chars[=N]`, `--ech[=N]`
* `--repeat[=N]`, `--rep[=N]` - Repeat preceding character N times.


Options - Cursor
----------------

The short version of these options comes from the command they are implementing.

* `--up[=N]`, `--cuu[=N]`
* `--down[=N]`, `--cud[=N]`
* `--forward[=N]`, `--cuf[=N]`
* `--backward[=N]`, `--cub[=N]`
* `--next-line[=N]`, `--cnl[=N]`
* `--previous-line[=N]`, `--prev-line[=N]`, `--cpl[=N]`
* `--column[=N]`, `--cha[=N]`
* `--position[=ROW][=COL]`, `--cup[=ROW][=COL]`
* `--tab-forward[=N]` - Move forward N tab stops.
* `--tab-backward[=N]` - Move backward N tab stops.
* `--column-relative[=N]`, `--hpr[=N]`
* `--line[=N]`, `--vpa[=N]`
* `--line-relative[=N]`, `--vpr[=N]`
* `--save-cursor` - Saves the cursor position.  By default, this will restore the cursor after writing text to the terminal unless you use `--no-restore`.
* `--restore-cursor` - This just restores the cursor position.  Normally this executes at the end when you use `--save-cursor`.
* `--hide-cursor` - This also will show the cursor at the end unless you use `--no-restore`.
* `--show-cursor`


Options - Text (Attributes)
-----------------------------

All of these options will automatically reset to normal text unless `--no-reset` is used. Below, the codes are grouped into similar functionality and the flag to disable that attribute is listed with the group it controls, so you can correlate the flags more easily.

* `--bold` and `--faint` can be reset with `--normal`
* `--italic` and `--fraktur` can be reset with `--plain`
* `--underline` and `--double-underline` are reset with `--no-underline`
* `--blink` and `--rapid-blink` are reset with `--no-blink`
* `--inverse` is removed with `--no-inverse`
* `--invisible` is changed back with `--visible`
* `--strike` is reset with `--no-strike`
* `--frame` and `--encircle` are reset with `--no-border`
* `--overline` is removed with `--no-overline`
* `--ideogram-right`, `--ideogram-right-double`, `--ideogram-left`, `--ideogram-left-double`, and `--ideogram-stress` are all removed with `--reset-ideogram`
* `--font=NUM` sets the font. `NUM` must be a single digit from 0 through 9. Font 0 is the default font.


Options - Text (Foreground)
-----------------------------

All of these options will automatically reset to the default color unless `--no-reset` is used. To preview the colors, use `--color-table`.

* `--black` and `--black-intense`
* `--red` and `--red-intense`
* `--yellow` and `--yellow-intense`
* `--blue` and `--blue-intense`
* `--magenta` and `--magenta-intense`
* `--cyan` and `--cyan-intense`
* `--white` and `--white-intense`
* `--color=CODE` lets you use one of 256 codes - preview the codes using `--color-codes`
* `--rgb=R,G,B` sets a specific color


Options - Text (Background)
-----------------------------

All of these options will automatically reset to the default color unless `--no-reset` is used. To preview the colors, use `--color-table`.

* `--bg-black` and `--bg-black-intense`
* `--bg-red` and `--bg-red-intense`
* `--bg-yellow` and `--bg-yellow-intense`
* `--bg-blue` and `--bg-blue-intense`
* `--bg-magenta` and `--bg-magenta-intense`
* `--bg-cyan` and `--bg-cyan-intense`
* `--bg-white` and `--bg-white-intense`
* `--bg-color=CODE` lets you use one of 256 codes - preview the codes using `--color-codes`
* `--bg-rgb=R,G,B` sets a specific color


Options - Text (Reset)
------------------------

These options force a reset of colors.  This is useful if you used `--no-reset` or are correcting the appearance of a misbehaving terminal.

* `--reset-attrib` - Reset all attributes
* `--reset-foreground` - Reset the foreground to default
* `--reset-background` - Reset the background to default
* `--reset-color` - Reset all color-related settings
* `--reset-font` - Reset the font to the primary font


Reporting
---------

All of these commands send a special code to the terminal.  The terminal responds as though someone typed something very fast.  In order for these to work, `ansi` must read from stdin directly.  This won't work if you are piping in a file or replace stdin in another way.

All output is written to screen.

* `--report-position` - ROW,COL
* `--report-window-state` - "open" or "iconified"
* `--report-window-position` - X,Y
* `--report-window-pixels` - HEIGHT,WIDTH
* `--report-window-chars` - ROWS,COLS
* `--report-screen-chars` - ROWS,COLS (this is for the entire screen)
* `--report-icon`
* `--report-title`


Miscellaneous
-------------

* `--color-table` - Display a color table.
* `--color-codes` - Show all of the 256 color codes.
* `--icon=NAME` - Set the icon.
* `--title=TITLE` - Set the title of the terminal.  The equals (=) before the `TITLE` parameter is mandatory.  `TITLE` can be empty.
* `--no-restore` - Do not issue reset codes when changing colors and saving the cursor.  For example, if you use `--green` then the text will automatically be reset to the default color when the command terminates.  With `--no-restore` set, the text will stay green and subsequent commands that output will keep writing in green until something else changes the terminal.
* `-n`, `--no-newline` - Do not add a newline at the end.
* `--escape` - Allow text passed in to contain escape sequences.
* `--bell` - Add the terminal's bell sequence to the output.
* `--reset` - Reset all colors, clear the screen, show the cursor and move to 1,1.


Demonstrations
--------------

### Colors

![](images/colors.gif)


### --color-table

![](images/color-table.png)


License
-------

This project is licensed under a MIT style license with an additional non-advertising clause.  See [LICENSE.md](LICENSE.md) for more information.
