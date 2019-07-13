ANSI Escape Sequences and Control Sequences
===========================================

Terminals are sent characters and they do a great job of displaying them. One can also send commands to terminals by sending special sequences of characters. The terminal will interpret them and perform the action as long as that sequence is supported.

This is a collection of all of the ANSI escape sequences I can find. Please help me to improve and add to this list if you know of some that are missing. These lists are verified the best I can and sources are listed so you can find more information.

**No terminal implements all codes!** The support of various sequences are dependent on the terminal supporting them. If you absolutely need something to work, you might need to switch terminals. Some of the sequences may not be implemented in any terminal. Many of these were made back in the days of dumb terminals and are no longer used.


Terminology and Format Explanation
----------------------------------

The codes will be listed using one of two format. This first format is describing the value of a single character.

| Code              | Description                                              |
|-------------------|----------------------------------------------------------|
| **033, 27, 0x1b** | A literal character value. This is the Escape character. |

The octal, decimal, and hexadecimal value of the character are all listed for convenience. The next format shows how to change the color.

| Code          | Description                              |
|---------------|------------------------------------------|
| `CSI {c} m`   | A sequence of characters.                |
| `CSI {n..} z` | Allow a series of numbers as parameters. |

The `CSI` translates into `ESC [` according to the table below, and `ESC` means the escape character (hex 0x27). `{c}` is a parameter to the operation, and `m` is the literal character "m". The second code has `{n..}` and it means a series of numbers, which is described later. If using the first format and the color code for blue (34), then this would be represented in your code as something like the following:

    # bash
    printf "%s" $'\033[34m'

    // JavaScript
    console.log(String.fromCharCode(27) + '[34m');

    // C
    printf("%c[34m", 0x1b);

This table lists the necessary prefixes and character codes.

| Code  | Description                 | 7-bit              | 8-bit               | Source        |
|-------|-----------------------------|--------------------|---------------------|---------------|
| ESC   | Escape                      | **033, 27, 0x1b**  | **033, 27, 0x1b**   | [E-CS]        |
| SP    | Space                       | **024, 20, 0x14**  | **024, 20, 0x14**   | [E-CS]        |
| GRAVE | Grave accent                | **0140, 96, 0x60** | **0140, 96, 0x60**  | [E-CS]        |
| CSI   | Control Sequence Introducer | `ESC [`            | **0233, 155, 0x9b** | [E-CF] [E-CS] |
| ST    | String Terminator           | `ESC \`            | **0234, 156, 0x9c** | [E-CF] [E-CS] |
| OSC   | Operating System Command    | `ESC ]`            | **0235, 157, 0x9d** | [E-CF] [E-CS] |

Normally `GRAVE` would not need to be called out, but it's a special character in Markdown. Because this document uses Markdown, it can't easily be represented in the document. It's also known as a backwards apostrophe or a backtick.

A practical reference of these codes can be found at [Wikipedia's C0 and C1 control codes](https://en.wikipedia.org/wiki/C0_and_C1_control_codes) and [ECMA's Control Functions For Coded Character Sets][E-CF]. The explanation of the allowed byte values is decrypted from [ECMA's 8-Bit Single-Byte Coded Graphic Character Set][E-CS].

### `CSI`

Control Sequence Introducer (CSI) starts a sequence. It can be followed by any number of parameters, then any number of intermediate bytes, and finally is terminated by a final byte.

The parameters are composed of numbers, plus some symbols. They are usually a single character (as found with `<`, `=`, `>`, and `?`) or they are one or more numeric parameters. The numeric parameters are separated by `;`. Numeric parameters may have leading zeros removed and the decimal should be replaced with `:`. The numeric parameters can be empty as well.

Here are some examples to help understand the meaning. I'm using the command `z` for illustrative purposes only.

    CSI z          No parameters.
    CSI 1 z        A single number (1) passed as the only parameter.
    CSI 0 1 z      Zeros are trimmed, so this is the same as above (1).
    CSI 1 2 z      A single number (12) passed.
    CSI 0 : 1 z    A single decimal parameter (0.1).
    CSI : 1 z      Same as above (0.1).
    CSI 1 ; 2 z    Two parameters (1, 2).
    CSI ; 2 z      Empty first parameter (null, 2).
    CSI 1 ; z      Empty last parameter (1, null)

Parameter bytes must be composed of these values.

    0 1 2 3 4 5 6 7 8 9 : ; < = > ?

The intermediate bytes are supposed to be bit flags for the commands.

    SPACE ! " # $ % & ' ( ) * + , - . /

The final byte is the command designator. It allows all alphabetic characters and several symbols.

    @ UPPERCASE_LETTERS [ \ ] ^ _
    ` LOWERCASE_LETTERS { | } ~

If you really want to get technical, the lowercase letters `o` through `z` and the symbols `{`, `|`, `}`, `~` are reserved for private or experimental use.


### `OSC`

The Operating System Command (OSC) sequence is the opening delimiter of a control string for operating system use. It is followed by printable characters (0x20 through 0x7e) and format effectors (0x08 through 0x0d). The end is flagged by String Terminator (ST), (`ESC \` or 0x9c).


Cursor Movement
---------------

| Code              | Description                                                                                    | Default | Source |
|-------------------|------------------------------------------------------------------------------------------------|---------|--------|
| `CSI {n} A`       | (CUU: Cursor Up) Moves the cursor up `{n}` lines.                                              | `1`     | [E-CF] |
| `CSI {n} B`       | (CUD: Cursor Down) Moves the cursor down `{n}` lines.                                          | `1`     | [E-CF] |
| `CSI {n} C`       | (CUF: Cursor Right) Moves the cursor forward / right `{n}` columns.                            | `1`     | [E-CF] |
| `CSI {n} D`       | (CUB: Cursor Left) Moves the cursor left / back `{n}` columns.                                 | `1`     | [E-CF] |
| `CSI {n} E`       | (CNL: Cursor Next Line) Moves cursor to first character of the `{n}` following line.           | `1`     | [E-CF] |
| `CSI {n} F`       | (CNL: Cursor Preceding Line) Moves cursor to first character of the `{n}` preceding line.      | `1`     | [E-CF] |
| `CSI {c} G`       | (CHA: Cursor Character Absolute) Move to column `{c}` on the current line.                     | `1`     | [E-CF] |
| `CSI {l} ; {c} H` | (CUP: Cursor Position) Move to line `{l}`, column `{c}`.                                       | `1;1`   | [E-CF] |
| `CSI {c} GRAVE`   | (HPA: Character Position Absolute) Move to column `{c}` in the active line.                    | `1`     | [E-CF] |
| `CSI {n} a`       | (HPR: Character Position Forward) Move the cursor forwards `{n}` characters.                   | `1`     | [E-CF] |
| `CSI {l} ; {c} f` | (HVP: Character Line and Position) Move the cursor down `{l}` lines and forward `{c}` columns. | `1;1`   | [E-CF] |
| `CSI {n} j`       | (HPB: Character Position Backward) Move the cursor backwards `{n}` characters.                 | `1`     | [E-CF] |


Display Modification
--------------------

| Code        | Description                                                                   | Default | Source |
|-------------|-------------------------------------------------------------------------------|---------|--------|
| `CSI {n} @` | (ICH: Insert Character) Insert `{n}` blanks at the cursor position.           | `1`     | [E-CF] |
| `CSI {p} J` | (ED: Erase In Page) Erase some or all of the screen. *See below.*             | `0`     | [E-CF] |
| `CSI {p} K` | (EL: Erase In Line) Erase some or all of the current line. *See below.*       | `0`     | [E-CF] |
| `CSI {n} L` | (IL: Insert Line) Insert `{n}` lines starting at cursor.                      | `1`     | [E-CF] |
| `CSI {n} M` | (DL: Delete Line) Delete `{n}` lines, shifting other lines to close the gap.  | `1`     | [E-CF] |
| `CSI {n} P` | (DCH: Delete Character) Delete `{n}` characters and shifts rest of line left. | `1`     | [E-CF] |
| `CSI {n} X` | (ECH: Erase Character) Erase `{n}` characters from cursor and going forward.  | `1`     | [E-CF] |


### `J`: Erase In Page (ED)

Format: `CSI {p} J`

Erases some or all of the screen. `{p}` defaults to `0`.

| `{p}` | Description                                            | Source |
|-------|--------------------------------------------------------|--------|
| `0`   | Erase from cursor through the end of the screen.       | [E-CF] |
| `1`   | Erase from beginning of the screen through the cursor. | [E-CF] |
| `2`   | Erase the entire screen.                               | [E-CF] |


### `K`: Erase In Line (ED)

Format: `CSI {p} K`

Erases some or all of the current line. `{p}` defaults to `0`.

| `{p}` | Description                                          | Source |
|-------|------------------------------------------------------|--------|
| `0`   | Erase from cursor through the end of the line.       | [E-CF] |
| `1`   | Erase from beginning of the line through the cursor. | [E-CF] |
| `2`   | Erase the entire line.                               | [E-CF] |


Fonts and Glyphs
----------------

| Code                 | Description                                                                              | Default   | Source |
|----------------------|------------------------------------------------------------------------------------------|-----------|--------|
| `CSI {h} ; {w} SP B` | (GSM: Graphic Size Modification) Change the text height and width. *See below.*          | `100;100` | [E-CF] |
| `CSI {p} SP C`       | (GSM: Graphic Size Selection) Change the size of the font. *See below.*                  | *none*    | [E-CF] |
| `CSI {f} ; {m} SP D` | (FNT: Font Selection) Changes font number `{f}` to be font `{m}`. *See below.*           | `0;0`     | [E-CF] |
| `CSI {n} SP _`       | (GCC: Graphic Character Combination) Overlays  characters as a single byte. *See below.* | `0`       | [E-CF] |


### `SP B`: Graphic Size Modification (GSM)

Format: `CSI {h} ; {w} SP B`

Modify the height and width of subsequent text of all primary and alternative fonts. The size stays in effect until the next Graphic Size Modification or Graphic Size Selection command. The height `{h}` and the width `{w}` are specified as percentages.


### `SP B`: Graphic Size Selection (GSS)

Format: `CSI {p} SP C`

Sets the height and width of all primary and alternative fonts for subsequent text. The size stays in effect until the next Graphic Size Selection command. `{p}` specifies the height. The width is implicitly defined by the height. The size unit is set by Select Size Unit.


### `SP D`: Font Selection (FNT)

Format: `CSI {f} ; {m} SP D`

Select the primary or secondary font to use for displaying subsequent occurrences of characters from the chosen character set. `{f}` determines the font based on the following table. `{m}` identifies the font according to a register.

| `{f}` | Description               | Source |
|-------|---------------------------|--------|
| `0`   | Primary font.             | [E-CF] |
| `1`   | First alternative font.   | [E-CF] |
| `2`   | Second alternative font.  | [E-CF] |
| `3`   | Third alternative font.   | [E-CF] |
| `4`   | Fourth alternative font.  | [E-CF] |
| `5`   | Fifth alternative font.   | [E-CF] |
| `6`   | Sixth alternative font.   | [E-CF] |
| `7`   | Seventh alternative font. | [E-CF] |
| `8`   | Eighth alternative font.  | [E-CF] |
| `9`   | Ninth alternative font.   | [E-CF] |


### `SP _`: Graphic Character Combination (GCC)

Format: `CSI {p} SP _`

Overlays two or more characters as a single character for display. `{p}` defaults to `0`. If more than two are to be overlaid, mark the start and end of the string of symbols.

| `{p}` | Description | Source |
|---|---|---|
| `0` | Overlay two characters. | [E-CF] |
[ `1` | Mark the beginning of overlaid characters. | [E-CF] |
[ `2` | Mark the end of overlaid characters. | [E-CF] |


Input
-----

The terminal gets to send escape sequences as well.

| Code           | Description                                                         | Default | Source |
|----------------|---------------------------------------------------------------------|---------|--------|
| `CSI {p} SP W` | (FNK: Function Key) `{p}` indicates which function key was pressed. | *none*  | [E-CF] |


Reporting and Queries
---------------------

| Code              | Description                                                                             | Default | Source |
|-------------------|-----------------------------------------------------------------------------------------|---------|--------|
| `CSI {p} SP M`    | (IGS: Identify Graphic Subrepertoire) Identifies graphic characters. *See below.*       | *none*  | [E-CF] |
| `CSI {p} SP O`    | (IDCS: Identify Device Control String) Specify type of future commands. *See below.*    | *none*  | [E-CF] |
| `CSI {p} N`       | (DSR: Device Status Report) Request or report the status of a device. *See below.*      | `0`     | [E-CF] |
| `CSI {l} ; {c} R` | (CPR: Active Position Report) Terminal reporting cursor is at line `{l}`, column `{c}`. | `1;1`   | [E-CF] |
| `CSI {p} c`       | (DA: Device Attributes) Request or send device type identification codes. *See below.*  | `0`     | [E-CF] |


### `SP M`: Identify Graphic Subrepertoire (IGS)

Format: `CSI {p} SP M`

Indicates that a repertoire of the graphic characters of ISO/IEC 10367 is used with the subsequent text. The parameter value identifies a graphic character repertoire registered in accordance with ISO/IEC 7350.


### `SP O`: Identify Device Control String (IDCS)

Format: `CSI {p} SP O`

Identifies the purpose and format of subsequent Device Control String sequences. The purpose and format remain in effect until the next Identify Device Control String.

| `{p}` | Description                                                       | Source |
|-------|-------------------------------------------------------------------|--------|
| `0`   | Used for the Diagnostic state of the Status Report Transfer Mode. | [E-CF] |
| `1`   | For Dynamically Redefinable Character Sets according to ECMA-15.  | [E-CF] |


### `N`: Device Status Report (DSR)

Format: `CSI {p} N`

When `{p}` is `5`, this requests the Device Status Report from a device / terminal. The response is sent as a Device Status Report sequence with a `{p}` value (and `0` could be omitted). Messages `0` through `4` can be sent unsolicited.

| `{p}` | Description                                                        | Source |
|-------|--------------------------------------------------------------------|--------|
| `0`   | Ready, no malfunction detected.                                    | [E-CF] |
| `1`   | Busy, another Device Status Report must be requested later.        | [E-CF] |
| `2`   | Busy, another Device Status Report will be sent later.             | [E-CF] |
| `3`   | Some malfunction detected, another report must be requested later. | [E-CF] |
| `4`   | Some malfunction detected, another report will be sent later.      | [E-CF] |
| `5`   | A Device Status Report is requested.                               | [E-CF] |
| `6`   | Request the cursor location in an Active Position Report format.   | [E-CF] |


### `c`: Device Attributes (DA)

Format: `CSI {p} c`

When `{p}` is `0`, this requests the Device Attributes from a device / terminal. The response should be sent as a Device Attributes sequence with a `{p}` value.


Tab Stops
---------

| Code          | Description                                                                       | Default | Source |
|---------------|-----------------------------------------------------------------------------------|---------|--------|
| `CSI {n} I`   | (CHT: Cursor Forward Tabulation) Move forward `{n}` tab stops.                    | `1`     | [E-CF] |
| `CSI {p..} W` | (CTC: Cursor Tabulation Control) Set or clear one or more tab stops. *See below.* | `1`     | [E-CF] |
| `CSI {n} Y`   | (CVT: Cursor Line Tabulation) Move forward `{n}` line tab stops.                  | `1`     | [E-CF] |
| `CSI {n} Z`   | (CBT: Cursor Backward Tabulation) Move back `{n}` character tab stops.            | `1`     | [E-CF] |


### `W`: Cursor Tabulation Control (CTC)

Format: `CSI {p..} W`

Multiple parameters may be sent. If none are sent, '{p..}' defaults to `1`.

| '{p}' | Description                                                         | Source |
|-------|---------------------------------------------------------------------|--------|
| `0`   | Set a character tab stop at the current position. *See note.*       | [E-CF] |
| `1`   | Set a line tab stop on the current line.                            | [E-CF] |
| `2`   | Clear a character tab stop at the current position. *See note.*     | [E-CF] |
| `3`   | Clear a line tab stop on the current line.                          | [E-CF] |
| `4`   | All character tab stops in the active line are cleared. *See note.* | [E-CF] |
| `5`   | All character tab stops are cleared.                                | [E-CF] |
| `6`   | All line tab stops are cleared.                                     | [E-CF] |

*Note:* For `0`, `2`, and `4`, the number of lines affected depends on the setting of the tab stop mode.

Examples:

| Code        | Description                                                                    | Source |
|-------------|--------------------------------------------------------------------------------|--------|
| `CSI W`     | Set a line tab stop on the current line.                                       | [E-CF] |
| `CSI 1 W`   | Same as default.                                                               | [E-CF] |
| `CSI 6 ; 1` | Clear all line tab stops and add a character tab stop at the current position. | [E-CF] |


Forms, Qualified Areas, and Fields
----------------------------------

Terminals were used for data entry. To make the forms behavior consistent and quick for the server to update, special codes were created. These are mostly unsupported now.

| Code                 | Description                                                                  | Default | Source |
|----------------------|------------------------------------------------------------------------------|---------|--------|
| `CSI {l} ; {c} SP T` | (DTA: Dimension Text Area) Create a text area. *See below.*                  | *none*  | [E-CF] |
| `CSI {p..} F`        | (JFY: Justify) Mark where special character formatting starts. *See below.*  | `0`     | [E-CF] |
| `CSI {p} N`          | (EF: Erase In Field) Erase some or all characters in a field. *See below.*   | `0`     | [E-CF] |
| `CSI {p} O`          | (EA: Erase In Area) Remove some or all characters from an area. *See below.* | `0`     | [E-CF] |
| `CSI {p..} o`        | (DAQ: Define Area Qualification) Create a new area. *See below.*             | `0`     | [E-CF] |


### `SP T`: Dimension Text Area

Format: `CSI {l} ; {c} SP T`

Creates a text area for subsequent pages. `{l}` is the number of lines, and `{c}` is the number of columns.

There is no default value.


### `F`: Justify (JFY)

Format: `CSI {p..} F`

Marks the beginning of a string of characters that should be formatted according to the values of `{p}`. This remains in effect until the next Justify command.

| `{p}` | Description | Source |
|---|---|---|
| `0` | No justification, end of justification of preceding text. | [E-CF] |
| `1` | Word fill. | [E-CF] |
| `2` | Word space. | [E-CF] |
| `3` | Letter space. | [E-CF] |
| `4` | Hyphenation. | [E-CF] |
| `5` | Left aligned. | [E-CF] |
| `6` | Centered. | [E-CF] |
| `7` | Right aligned. | [E-CF] |
| `8` | Italian hypenation. | [E-CF] |


### `N`: Erase in Field (EF)

Format: `CSI {o} N`

Erases some or all of the characters from a field, depending on the value of `{p}`. It defaults to `0` when `{p}` is not specified.

| `{p}` | Description                                                   | Source |
|-------|---------------------------------------------------------------|--------|
| `0`   | Erase from cursor to end of field.                            | [E-CF] |
| `1`   | Erase from beginning of field up to and including the cursor. | [E-CF] |
| `2`   | Erase all character positions in the field.                   | [E-CF] |


### `O`: Erase in Area (EA)

Format: `CSI {o} O`

Erases some or all of the characters from a qualified area, depending on the value of `{p}`. It defaults to `0` when `{p}` is not specified.

| `{p}` | Description                                                  | Source |
|-------|--------------------------------------------------------------|--------|
| `0`   | Erase from cursor to end of area.                            | [E-CF] |
| `1`   | Erase from beginning of area up to and including the cursor. | [E-CF] |
| `2`   | Erase all character positions in the area.                   | [E-CF] |


### `o`: Define Area Qualification (DAQ)

Format: `CSI {p..} o`

Sets up a new qualified area. The area starts at the current cursor position and ends the character before the next qualified area. `{p}` can be one or more values.

| `{p}` | Description                            | Source |
|-------|----------------------------------------|--------|
| `0`   | Unprotected and unguarded.             | [E-CF] |
| `1`   | Protected and guarded.                 | [E-CF] |
| `2`   | Graphic character input.               | [E-CF] |
| `3`   | Numeric input.                         | [E-CF] |
| `4`   | Alphabetic input.                      | [E-CF] |
| `5`   | Input is right-aligned.                | [E-CF] |
| `6`   | Fill with zeros.                       | [E-CF] |
| `7`   | Set a character tab stop here.         | [E-CF] |
| `8`   | Protected and guarded.                 | [E-CF] |
| `9`   | Fill with spaces.                      | [E-CF] |
| `10`  | Input is left-aligned.                 | [E-CF] |
| `11`  | Order of input characters is reversed. | [E-CF] |


Sources
-------

* E-CF: [ECMA's Control Functions For Coded Character Sets][E-CF]
* E-CS: [ECMA's 8-Bit Single-Byte Coded Graphic Character Sets][E-CS]
* Wikipedia's [ANSI Escape Code](https://en.wikipedia.org/wiki/ANSI_escape_code)

[E-CF]: http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-048.pdf
[E-CS]: https://www.ecma-international.org/publications/files/ECMA-ST/Ecma-114.pdf

CSI 8.3.73 52
OSC

ECMA codes
https://www.ecma-international.org/publications/files/ECMA-ST/Ecma-114.pdf

ECMA
http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-048.pdf

http://microvga.com/ansi-codes
http://man7.org/linux/man-pages/man4/console_codes.4.html
https://wiki.archlinux.org/index.php/Bash/Prompt_customization
http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/c327.html
https://invisible-island.net/xterm/ctlseqs/ctlseqs.html
http://www.termsys.demon.co.uk/vtansi.htm
https://wiki.bash-hackers.org/scripting/terminalcodes
https://www.itu.int/rec/T-REC-T.416/en
https://www.itu.int/rec/T-REC-T.412/en
http://ascii-table.com/ansi-escape-sequences-vt-100.php
https://gist.github.com/XVilka/8346728
https://bluesock.org/~willkg/dev/ansi.html
http://ascii-table.com/ansi-escape-sequences.php
https://en.wikipedia.org/wiki/ANSI_escape_code
http://www.shaels.net/index.php/propterm/documents/14-ansi-protocol
examples of Mosh
