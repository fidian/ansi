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

This table lists the necessary prefixes and character codes for the rest of the escape sequences.

| Code  | Description                           | 7-bit               | 8-bit               | Source        |
|-------|---------------------------------------|---------------------|---------------------|---------------|
| LF    | Line Feed                             | **012, 10, 0x0a**   | **012, 10, 0x0a**   | [E-CF] [W-CC] |
| VT    | Vertical Tabulation / Line Tabulation | **013, 11, 0x0b**   | **013, 11, 0x0b**   | [E-CF] [W-CC] |
| FF    | Form Feed                             | **014, 12, 0x0c**   | **014, 12, 0x0c**   | [E-CF] [W-CC] |
| CR    | Carriage Return                       | **015, 13, 0x0d**   | **015, 13, 0x0d**   | [E-CF] [W-CC] |
| SP    | Space                                 | **024, 20, 0x14**   | **024, 20, 0x14**   | [E-CS] [W-CC] |
| ESC   | Escape                                | **033, 27, 0x1b**   | **033, 27, 0x1b**   | [E-CS] [W-CC] |
| GRAVE | Grave Accent                          | **0140, 96, 0x60**  | **0140, 96, 0x60**  | [E-CS] [W-GA] |
| NEL   | Next Line                             | **0205, 133, 0x85** | **0205, 133, 0x85** | [E-CF] [W-CC] |
| RI    | Reverse Line Feed                     | **0215, 141, 0x8d** | **0215, 141, 0x8d** | [E-CF] [W-CC] |
| CSI   | Control Sequence Introducer           | `ESC [`             | **0233, 155, 0x9b** | [E-CF] [E-CS] |
| ST    | String Terminator                     | `ESC \`             | **0234, 156, 0x9c** | [E-CF] [E-CS] |
| OSC   | Operating System Command              | `ESC ]`             | **0235, 157, 0x9d** | [E-CF] [E-CS] |

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
| `CSI {p} ^`       | (SIMD: Select Implicit Movement Direction) Sets cursor movement direction. *See below.*        | `0`     | [E-CF] |
| `CSI {c} GRAVE`   | (HPA: Character Position Absolute) Move to column `{c}` in the active line.                    | `1`     | [E-CF] |
| `CSI {n} a`       | (HPR: Character Position Forward) Move the cursor forwards `{n}` characters.                   | `1`     | [E-CF] |
| `CSI {n} d`       | (VPA: Line Position Absolute) Move straight up or down to line `{n}`.                          | `1`     | [E-CF] |
| `CSI {n} e`       | (VPR: Line Position Forward) Move down `{n}` lines.                                            | `1`     | [E-CF] |
| `CSI {l} ; {c} f` | (HVP: Character Line and Position) Move the cursor down `{l}` lines and forward `{c}` columns. | `1;1`   | [E-CF] |
| `CSI {n} j`       | (HPB: Character Position Backward) Move the cursor backwards `{n}` characters.                 | `1`     | [E-CF] |
| `CSI {n} k`       | (VPB: Line Position Backward) Move up `{n}` lines.                                             | `1`     | [E-CF] |


### `^`: Set Implicit Movement Direction (SIMD)

Format: `CSI {p} ^`

Sets the cursor movement direction relative to the character progression. Default value is `0`.

| `{p}` | Description | Source |
|---|---|---|
| `0` | Same as character progression. | [E-CF] |
| `1` | Opposite of character progression. | [E-CF] |


Display Modification
--------------------

| Code                 | Description                                                                      | Default | Source |
|----------------------|----------------------------------------------------------------------------------|---------|--------|
| `CSI {n} SP @`       | (SL: Scroll Left) Moves displayed text left `{n}` columns.                       | `1`     | [E-CF] |
| `CSI {n} SP A`       | (SR: Scroll Right) Moves displayed text right `{n}` columns.                     | `1`     | [E-CF] |
| `CSI {d} ; {e} SP S` | (SPD: Set Presentation Direction) Sets text direction. *See below.*              | `0;0`   | [E-CF] |
| `CSI {n} @`          | (ICH: Insert Character) Insert `{n}` blanks at the cursor position.              | `1`     | [E-CF] |
| `CSI {p} J`          | (ED: Erase In Page) Erase some or all of the screen. *See below.*                | `0`     | [E-CF] |
| `CSI {p} K`          | (EL: Erase In Line) Erase some or all of the current line. *See below.*          | `0`     | [E-CF] |
| `CSI {n} L`          | (IL: Insert Line) Insert `{n}` lines starting at cursor.                         | `1`     | [E-CF] |
| `CSI {n} M`          | (DL: Delete Line) Delete `{n}` lines, shifting other lines to close the gap.     | `1`     | [E-CF] |
| `CSI {n} P`          | (DCH: Delete Character) Delete `{n}` characters and shifts rest of line left.    | `1`     | [E-CF] |
| `CSI {n} S`          | (SU: Scroll Up) Scroll display up `{n}` lines.                                   | `1`     | [E-CF] |
| `CSI {n} T`          | (SD: Scroll Down) Scroll display down `{n}` lines.                               | `1`     | [E-CF] |
| `CSI {n} U`          | (NP: Next Page) Display the `{n}`th page to be displayed.                        | `1`     | [E-CF] |
| `CSI {n} V`          | (PP: Preceding Page) Display the `{n}`th previous page.                          | `1`     | [E-CF] |
| `CSI {n} X`          | (ECH: Erase Character) Erase `{n}` characters from cursor and going forward.     | `1`     | [E-CF] |
| `CSI {n} b`          | (REP: Repeat) Repeat preceding character `{n}` times.                            | `1`     | [E-CF] |
| `CSI {p..} m`        | (SGR: Select Graphic Rendition) Set colors, fonts, and many others. *See below.* | `0`     | [E-CF] |


### `SP S`: Set Presentation Direction (SPD)

Format: `CSI {d} ; {e} SP S`

Sets the presentation direction according to `{d}` and with effector `{e}`. The default value is `0;0`.

| `{d}` | Description | Source |
|---|---|---|
| `0` | Horizontal lines from top to bottom. Lines fill left to right. | [E-CF] |
| `1` | Vertical lines from right to left. Lines fill top to bottom. | [E-CF] |
| `2` | Vertical lines from left to right. Lines fill top to bottom. | [E-CF] |
| `3` | Horizontal lines from top to bottom. Lines fill right to left. | [E-CF] |
| `4` | Vertical lines from left to right. Lines fill bottom to top. | [E-CF] |
| `5` | Horizontal lines from bottom to top. Lines fill right to left. | [E-CF] |
| `6` | Horizontal lines from bottom to top. Lines fill left to right. | [E-CF] |
| `7` | Vertical lines from right to left. Lines fill bottom to top. | [E-CF] |

| `{e}` | Description                                                                          | Source |
|-------|--------------------------------------------------------------------------------------|--------|
| `0`   | Undefined, implementation dependent.                                                 | [E-CF] |
| `1`   | Update active line in presentation component to match active line in data component. | [E-CF] |
| `2`   | Update active line in data component to match active line in presentation component. | [E-CF] |


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


### `m`: Select Graphic Rendition (SGR)

Format: `CSI {p..} m`

Sets one or more graphic rendition aspects for subsequent text. The default is `0` and the implementation determines what combinations are usable.

| `{p}` | Description                                             | Source |
|-------|---------------------------------------------------------|--------|
| `0`   | Clear any effect, reset, restore to normal.             | [E-CF] |
| `1`   | Bold intensity.                                         | [E-CF] |
| `2`   | Faint intensity.                                        | [E-CF] |
| `3`   | Italic.                                                 | [E-CF] |
| `4`   | Underline.                                              | [E-CF] |
| `5`   | Slow blinking (less than 150 per minute)                | [E-CF] |
| `6`   | Rapid blinking (more than 150 per minute)               | [E-CF] |
| `7`   | Inverse video / negative image.                         | [E-CF] |
| `8`   | Concealed characters.                                   | [E-CF] |
| `9`   | Crossed-out characters / strike-through.                | [E-CF] |
| `10`  | Primary (default) font.                                 | [E-CF] |
| `11`  | First alternative font.                                 | [E-CF] |
| `12`  | Second alternative font.                                | [E-CF] |
| `13`  | Third alternative font.                                 | [E-CF] |
| `14`  | Fourth alternative font.                                | [E-CF] |
| `15`  | Fifth alternative font.                                 | [E-CF] |
| `16`  | Sixth alternative font.                                 | [E-CF] |
| `17`  | Seventh alternative font.                               | [E-CF] |
| `18`  | Eighth alternative font.                                | [E-CF] |
| `19`  | Ninth alternative font.                                 | [E-CF] |
| `20`  | Fraktur (Gothic).                                       | [E-CF] |
| `21`  | Double underline.                                       | [E-CF] |
| `22`  | Reset color and set normal intensity.                   | [E-CF] |
| `23`  | Turn off italic and fraktur.                            | [E-CF] |
| `24`  | Turn off underline (single or double).                  | [E-CF] |
| `25`  | Turn off blinking text.                                 | [E-CF] |
| `26`  | *Reserved for proportional spacing.*                    | [E-CF] |
| `27`  | Turn off inverse video.                                 | [E-CF] |
| `28`  | Turn off concealed characters.                          | [E-CF] |
| `29`  | Turn off strike-through.                                | [E-CF] |
| `30`  | Black foreground color.                                 | [E-CF] |
| `31`  | Red foreground color.                                   | [E-CF] |
| `32`  | Green foreground color.                                 | [E-CF] |
| `33`  | Yellow foreground color.                                | [E-CF] |
| `34`  | Blue foreground color.                                  | [E-CF] |
| `35`  | Magenta foreground color.                               | [E-CF] |
| `36`  | Cyan foreground color.                                  | [E-CF] |
| `37`  | White foreground color.                                 | [E-CF] |
| `38`  | *Reserved for future standardization.*                  | [E-CF] |
| `39`  | Reset foreground color to default.                      | [E-CF] |
| `40`  | Black background color.                                 | [E-CF] |
| `41`  | Red background color.                                   | [E-CF] |
| `42`  | Green background color.                                 | [E-CF] |
| `43`  | Yellow background color.                                | [E-CF] |
| `44`  | Blue background color.                                  | [E-CF] |
| `45`  | Magenta background color.                               | [E-CF] |
| `46`  | Cyan background color.                                  | [E-CF] |
| `47`  | White background color.                                 | [E-CF] |
| `48`  | *Reserved for future standardization.*                  | [E-CF] |
| `49`  | Reset background color to default.                      | [E-CF] |
| `50`  | *Reserved for canceling proportional spacing.*          | [E-CF] |
| `51`  | Frame.                                                  | [E-CF] |
| `52`  | Encircle.                                               | [E-CF] |
| `53`  | Overlined.                                              | [E-CF] |
| `54`  | Turn off frame, encircle.                               | [E-CF] |
| `55`  | Turn off overline.                                      | [E-CF] |
| `56`  | *Reserved for future standardization.*                  | [E-CF] |
| `57`  | *Reserved for future standardization.*                  | [E-CF] |
| `58`  | *Reserved for future standardization.*                  | [E-CF] |
| `59`  | *Reserved for future standardization.*                  | [E-CF] |
| `60`  | Ideogram underline or right side line.                  | [E-CF] |
| `61`  | Ideogram double underline or double line on right side. | [E-CF] |
| `62`  | Ideogram overline or left side line.                    | [E-CF] |
| `63`  | Ideogram double overline or double line on left side.   | [E-CF] |
| `64`  | Ideogram stress marking.                                | [E-CF] |
| `65`  | Cancels the ideogram rendition aspects.                 | [E-CF] |


Fonts and Glyphs
----------------

| Code                 | Description                                                                              | Default   | Source |
|----------------------|------------------------------------------------------------------------------------------|-----------|--------|
| `CSI {h} ; {w} SP B` | (GSM: Graphic Size Modification) Change the text height and width. *See below.*          | `100;100` | [E-CF] |
| `CSI {p} SP C`       | (GSM: Graphic Size Selection) Change the size of the font. *See below.*                  | *none*    | [E-CF] |
| `CSI {f} ; {m} SP D` | (FNT: Font Selection) Changes font number `{f}` to be font `{m}`. *See below.*           | `0;0`     | [E-CF] |
| `CSI {p} SP E`       | (TSS: Thin Space Specification) Sets width of a thin space. *See below.*                 | *none*    | [E-CF] |
| `CSI {l} ; {c} SP G` | (SPI: Spacing Increment) Changes line and character spacing. *See below.*                | *none*    | [E-CF] |
| `CSI {p} SP I`       | (SSU: Select Size Unit) Pick a unit that affects several commands. *See below.*          | `0`       | [E-CF] |
| `CSI {p} SP K`       | (SHS: Select Character Spacing) Sets spacing for subsequent text. *See below.*           | `0`       | [E-CF] |
| `CSI {p} SP L`       | (SVS: Select Line Spacing) Sets line spacing. *See below.*                               | `0`       | [E-CF] |
| `CSI {p} SP Z`       | (PEC: Presentation Expand Or Contract) Set character spacing. *See below.*               | `0`       | [E-CF] |
| `CSI {p} SP [`       | (SSW: Set Space Width) Sets the character escapement. *See below.*                       | *none*    | [E-CF] |
| `CSI {p..} SP ]`     | (SAPV: Select Alternative Presentation Variants) Display text differently. *See below.*  | `0`       | [E-CF] |
| `CSI {p} SP \`       | (SACS: Set Additional Character Separation) Sets character separation. *See below.*      | `0`       | [E-CF] |
| `CSI {n} SP _`       | (GCC: Graphic Character Combination) Overlays  characters as a single byte. *See below.* | `0`       | [E-CF] |
| `CSI {p} SP f`       | (SRCS: Set Reduced Character Separation) Condenses text by removing space. *See below.*  | `0`       | [E-CF] |
| `CSI {p} SP g`       | (SCS: Set Character Spacing) Sets spacing of following text. *See below.*                | *none*    | [E-CF] |
| `CSI {p} SP h`       | (SLS: Set Line Spacing) Sets line spacing of following text. *See below.*                | *none*    | [E-CF] |
| `CSI {p} H`          | (QUAD: Quad) Align and justify characters. *See below.*                                  | `0`       | [E-CF] |


### `SP B`: Graphic Size Modification (GSM)

Format: `CSI {h} ; {w} SP B`

Modify the height and width of subsequent text of all primary and alternative fonts. The size stays in effect until the next Graphic Size Modification or Graphic Size Selection command. The height `{h}` and the width `{w}` are specified as percentages.


### `SP C`: Graphic Size Selection (GSS)

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


### `SP E`: Thin Space Specification (TSS)

Format: `CSI {p} SP E`

Sets the width of a thin space for subsequent text. Uses the unit specified by Select Size Unit. No default value for `{p}`.


### `SP G`: Spacing Increment (SPI)

Format: `CSI {l} ; {c} SP G`

Sets the line spacing `{l}` and character spacing `{c}` for subsequent text. The line spacing remains in effect until the next Spacing Increment, Set Line Spacing, or Select Line Spacing. The character spacing remains in effect until the next Set Character Spacing or Select Character Spacing. There is no default value. The unit in which the parameter values are expressed are established by Select Size Unit.


### `SP I`: Select Size Unit (SSU)

Format: `CSI {p} SP I`

Sets the unit that applies to the numeric parameters of certain control functions. The unit remains in effect until the next Select Size Unit command. The default value is `0`.

| `{p}` | Description                                                      | Source |
|-------|------------------------------------------------------------------|--------|
| `0`   | Character: The dimensions are device-dependent.                  | [E-CF] |
| `1`   | Millimeter.                                                      | [E-CF] |
| `2`   | Computer Decipoint: 0.03528 mm (1/720 of 25.4 mm).               | [E-CF] |
| `3`   | Decidot: 0.03759 mm (10/266 mm).                                 | [E-CF] |
| `4`   | Mil: 0.0254 mm (1/1000 of 25.4 mm).                              | [E-CF] |
| `5`   | Basic Measuring Unit (BMU): 0.02117 mm (1/1200 of 25.4 mm).      | [E-CF] |
| `6`   | Micrometer: 0.001 mm.                                            | [E-CF] |
| `7`   | Pixel: The smallest increment that can be specified in a device. | [E-CF] |
| `8`   | Decipoint: 0.03514 mm (35/996 mm).                               | [E-CF] |


### `SP K`: Select Character Spacing (SHS)

Format: `CSI {p} SP K`

Sets the character spacing that should be used for subsequent text. Remains in effect until the next Select Character Spacing, Set Character Spacing, or Spacing Increment. Defaults to `0`.

| `{p}` | Description                | Source |
|-------|----------------------------|--------|
| `0`   | 10 characters per 25.4 mm. | [E-CF] |
| `1`   | 12 characters per 25.4 mm. | [E-CF] |
| `2`   | 15 characters per 25.4 mm. | [E-CF] |
| `3`   | 6 characters per 25.4 mm.  | [E-CF] |
| `4`   | 3 characters per 25.4 mm.  | [E-CF] |
| `5`   | 9 characters per 50.8 mm.  | [E-CF] |
| `6`   | 4 characters per 25.4 mm.  | [E-CF] |


### `SP L`: Select Line Spacing (SVS)

Format: `CSI {p} SP L`

Sets line spacing for subsequent text. Remains in effect until Select Line Spacing, Set Line Spacing, or Spacing Increment. Defaults to `0`.

| `{p}` | Description           | Source |
|-------|-----------------------|--------|
| `0`   | 6 lines per 25.4 mm.  | [E-CF] |
| `1`   | 4 lines per 25.4 mm.  | [E-CF] |
| `2`   | 3 lines per 25.4 mm.  | [E-CF] |
| `3`   | 12 lines per 25.4 mm. | [E-CF] |
| `4`   | 8 lines per 25.4 mm.  | [E-CF] |
| `5`   | 6 lines per 30 mm.    | [E-CF] |
| `6`   | 4 lines per 30 mm.    | [E-CF] |
| `7`   | 3 lines per 30 mm.    | [E-CF] |
| `8`   | 12 lines per 30 mm.   | [E-CF] |
| `9`   | 2 lines per 25.4 mm.  | [E-CF] |


### `SP Z`: Presentation Expand or Contract (PEC)

Format: `CSI {p} SP Z`

Sets the spacing and extent of the characters.

| `{p}` | Description                                          | Source |
|-------|------------------------------------------------------|--------|
| `0`   | Normal.                                              | [E-CF] |
| `1`   | Expanded. Multiplied by a factor not greater than 2. | [E-CF] |
| `2`   | Condensed. Multiplied by a factor not less than 0.5. | [E-CF] |


### `SP [`: Set Space Width (SSW)

Format: `CSI {p} SP [`

Sets the character escapement associated with subsequent space characters. Value remains in effect until the next Set Space Width, Carriage Return, Line Feed, Form Feed, or Next Line. `{p}` specifies the escapement in units specified by Select Size Unit. The default character escapement of space is specified by the most recent occurrence of Set Character Spacing, Select Character Spacing, Select Spacing Increment, or specified by the nominal width of the space character in the current font if that font has proportional spacing.


### `SP ]`: Select Alternative Presentation Variants (SAPV)

Format: `CSI {p..} SP ]`

Sets one or more variants for the presentation of subsequent text. The default `{p..}` is 0.

| `{p}` | Description                                                               | Source |
|-------|---------------------------------------------------------------------------|--------|
| `0`   | Default presentation. Clears any presentation variant.                    | [E-CF] |
| `1`   | Decimal digits are displayed in Latin script.                             | [E-CF] |
| `2`   | Decimal digits are displayed in Arabic script.                            | [E-CF] |
| `3`   | Flip parenthesis, brackets, braces, greater-than/less-than, etc.          | [E-CF] |
| `4`   | Mirror mathematical operators around the vertical axis.                   | [E-CF] |
| `5`   | The following character is displayed in its isolated form.                | [E-CF] |
| `6`   | The following character is displayed in its initial form.                 | [E-CF] |
| `7`   | The following character is displayed in its medial form.                  | [E-CF] |
| `8`   | The following character is displayed in its final form.                   | [E-CF] |
| `9`   | Change periods into the symbol for full stop.                             | [E-CF] |
| `10`  | Change periods into commas.                                               | [E-CF] |
| `11`  | Vowels are presented above of below the preceding character.              | [E-CF] |
| `12`  | Vowels are presented after the preceding character.                       | [E-CF] |
| `13`  | Contextual shape determination of Arabic script and LAM-ALEPH ligatures.  | [E-CF] |
| `14`  | Contextual shape determination of Arabic scripts excluding all ligatures. | [E-CF] |
| `15`  | Cancels effects of `3` and `4`.                                           | [E-CF] |
| `16`  | Vowels are not presented.                                                 | [E-CF] |
| `17`  | Italicized characters are slanted the opposite direction.                 | [E-CF] |
| `18`  | Do not use shape determination - display character as they are stored.    | [E-CF] |
| `19`  | Same as `18` but does not apply to numbers.                               | [E-CF] |
| `20`  | The digit symbols are device dependent.                                   | [E-CF] |
| `21`  | Apply `5`, `6`, `7`, and `8` until canceled.                              | [E-CF] |
| `22`  | Cancels the effects of `21`.                                              | [E-CF] |


### `SP \`: Set Additional Character Separation (SACS)

Format: `CSI {p} SP \`

Establishes inter-character escapement for subsequent text. This remains in effect until the next Set Additional Character Separation, Set Reduced Character Separation, Carriage Return, Line Feed, or Next Line. `{p}` defaults to 0 and is measured by the unit established by Select Size Unit.


### `SP _`: Graphic Character Combination (GCC)

Format: `CSI {p} SP _`

Overlays two or more characters as a single character for display. `{p}` defaults to `0`. If more than two are to be overlaid, mark the start and end of the string of symbols.

| `{p}` | Description                                | Source |
|-------|--------------------------------------------|--------|
| `0`   | Overlay two characters.                    | [E-CF] |
| `1`   | Mark the beginning of overlaid characters. | [E-CF] |
| `2`   | Mark the end of overlaid characters.       | [E-CF] |


### `SP f`: Set Reduced Character Separation

Format: `CSI {p} SP f`

Sets reduced inter-character escapement for subsequent text and remains in effect until the next Set Reduced Character Separation, Set Additional Character Separation, Carriage Return, Line Feed, or Next Line. `{p}` specifies the number of units, which were assigned by Select Size Unit. The default is `0`.


### `SP g`: Set Character Spacing (SCS)

Format: `CSI {p} SP g`

Sets the character spacing for subsequent text. The unit is determined by Select Size Unit. Spacing setting remains in effect until the next Set Character Spacing, Select Character Spacing, or Spacing Increment. There is no default value.


### `SP h`: Set Line Spacing (SLS)

Format: `CSI {p} SP h`

Sets the line spacing for subsequent text. The unit is determined by Select Size Unit. Spacing setting remains in effect until the next Set Line Spacing, Select Line Spacing, or Spacing Increment. There is no default value.


### `H`: Quad (QUAD)

Format: `CSI {p} H`

Indicate the end of a string of characters that should be positioned on a single line according to `{p}`, which defaults to `0`.

| `{p}` | Description                         | Source |
|-------|-------------------------------------|--------|
| `0`   | Left aligned.                       | [E-CF] |
| `1`   | Left aligned and fill with leader.  | [E-CF] |
| `2`   | Centered.                           | [E-CF] |
| `3`   | Centered and fill with leader.      | [E-CF] |
| `4`   | Right aligned.                      | [E-CF] |
| `5`   | Right aligned and fill with header. | [E-CF] |
| `6`   | Flush to both margins.              | [E-CF] |

The beginning of the string to be positioned is indicated by the preceding occurrence of Quad, Form Feed, Character and Line Position, Line Feed, Next Line, Page Position Absolute, Page Position Backward, Page Position Forward, Reverse Line Feed, Line Position Absolute, Line Position Backward, Line Position Forward, or Line Tabulation.


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


Tab Stops and Boundaries
------------------------

| Code                 | Description                                                                          | Default     | Source |
|----------------------|--------------------------------------------------------------------------------------|-------------|--------|
| `CSI {n} SP U`       | (SLH: Set Line Home) Sets the starting position for lines. *See below.*              | *none*      | [E-CF] |
| `CSI {n} SP V`       | (SLH: Set Line Limit) Sets the ending position for lines. *See below.*               | *none*      | [E-CF] |
| `CSI {n} SP ^`       | (STAB: Selective Tabulation) Align text according to `{n}`th tab stop.               | *none*      | [E-CF] |
| `CSI {n} SP GRAVE`   | (TALE: Tabulation Aligned Trailing Edge) Set right-aligned tab stop at column `{n}`. | *none*      | [E-CF] |
| `CSI {n} SP a`       | (TALE: Tabulation Aligned Leading Edge) Set left-aligned tab stop at column `{n}`.   | *none*      | [E-CF] |
| `CSI {n} SP b`       | (TAC: Tabulation Aligned Centered) Set centered tab stop at `{n}`th column.          | *none*      | [E-CF] |
| `CSI {n} ; {c} SP c` | (TCC: Tabulation Centered On Character) Center text on a character. *See below.*     | *none*`;32` | [E-CF] |
| `CSI {n} SP d`       | (TSR: Tabulation Stop Remove) Removes tab stop at column `{n}`.                      | *none*      | [E-CF] |
| `CSI {n} SP i`       | (SPH: Set Page Home) Sets the starting position for the page. *See below.*           | *none*      | [E-CF] |
| `CSI {n} SP j`       | (SPH: Set Page Limit) Sets the ending position for the active page.                  | *none*      | [E-CF] |
| `CSI {n} I`          | (CHT: Cursor Forward Tabulation) Move forward `{n}` tab stops.                       | `1`         | [E-CF] |
| `CSI {p..} W`        | (CTC: Cursor Tabulation Control) Set or clear one or more tab stops. *See below.*    | `1`         | [E-CF] |
| `CSI {n} Y`          | (CVT: Cursor Line Tabulation) Move forward `{n}` line tab stops.                     | `1`         | [E-CF] |
| `CSI {n} Z`          | (CBT: Cursor Backward Tabulation) Move back `{n}` character tab stops.               | `1`         | [E-CF] |
| `CSI {p} g`          | (TBC: Tabulation Clear) Clear one or more tab stops. *See below.*                    | `0`         | [E-CF] |


### `SP U`: Set Line Home (SLH)

Format: `CSI {n} SP U`

Sets position `{n}` in the active line to be the home position for the active line and subsequent lines of text. Carriage Return, Delete Line, Insert Line, and Next Line will all use this as their home positions. This remains in effect until the next Set Line Home command.


### `SP V`: Set Line Limit (SLL)

Format: `CSI {n} SP V`

Sets position `{n}` in the active line to be the end position for the active line and subsequent lines of text. Carriage Return and Next Line will use this position if their Set Implicit Movement Direction is set to `1`. This remains in effect until the next Set Line Limit command.


### `SP c`: Tabulation Centered On Character (TCC)

Format: `CSI {n} ; {c} SP c`

Sets a tab stop at character position `{n}` in the active line and of lines of subsequent text. Replaces any tab stop at the same location, but does not affect other tab stops. Strings are centered on the tab stop on the first occurrence of the character within the string. If the character does not appear, the text will be left aligned to the tab stop.

There is no default value for `{n}`. `{c}` defaults to `32`, which is a space. Allowed values for `{c}` are `32`-`127` and also includes `160`-`255` for 8-bit codes.


### `SP i`: Set Page Home (SPH)

Format: `CSI {n} SP i`

Sets line position `{n}` to be the home position for the active page. Form Feed will advance the next page to this position.


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


### `g`: Tabulation Clear (TBC)

Format: `CSI {p} g`

Clears one or more tab stops based on the value of `{p}`, which defaults to `0`.

| `{p}` | Description                                                                        | Source |
|-------|------------------------------------------------------------------------------------|--------|
| `0`   | Clear the character tab stop at active position. Affected by Tabulation Stop Mode. | [E-CF] |
| `1`   | Clear the line tab stop at the active line.                                        | [E-CF] |
| `2`   | Clear all tab stops in the active line.  Affected by Tabulation Stop Mode.         | [E-CF] |
| `3`   | Clear all character tabulation stops.                                              | [E-CF] |
| `4`   | Clear all line tabulation stops.                                                   | [E-CF] |
| `5`   | Clear all tabulation stops.                                                        | [E-CF] |


Forms, Qualified Areas, and Fields
----------------------------------

Terminals were used for data entry. To make the forms behavior consistent and quick for the server to update, special codes were created. These are mostly unsupported now.

| Code                 | Description                                                                  | Default | Source |
|----------------------|------------------------------------------------------------------------------|---------|--------|
| `CSI {l} ; {c} SP T` | (DTA: Dimension Text Area) Create a text area. *See below.*                  | *none*  | [E-CF] |
| `CSI {p..} F`        | (JFY: Justify) Mark where special character formatting starts. *See below.*  | `0`     | [E-CF] |
| `CSI {p} N`          | (EF: Erase In Field) Erase some or all characters in a field. *See below.*   | `0`     | [E-CF] |
| `CSI {p} O`          | (EA: Erase In Area) Remove some or all characters from an area. *See below.* | `0`     | [E-CF] |
| `CSI {p} Q`          | (SEE: Select Editing Extent) Set editing extent. *See below.*                | `0`     | [E-CF] |
| `CSI {p..} o`        | (DAQ: Define Area Qualification) Create a new area. *See below.*             | `0`     | [E-CF] |


### `SP T`: Dimension Text Area

Format: `CSI {l} ; {c} SP T`

Creates a text area for subsequent pages. `{l}` is the number of lines, and `{c}` is the number of columns.

There is no default value.


### `F`: Justify (JFY)

Format: `CSI {p..} F`

Marks the beginning of a string of characters that should be formatted according to the values of `{p}`. This remains in effect until the next Justify command.

| `{p}` | Description                                               | Source |
|-------|-----------------------------------------------------------|--------|
| `0`   | No justification, end of justification of preceding text. | [E-CF] |
| `1`   | Word fill.                                                | [E-CF] |
| `2`   | Word space.                                               | [E-CF] |
| `3`   | Letter space.                                             | [E-CF] |
| `4`   | Hyphenation.                                              | [E-CF] |
| `5`   | Left aligned.                                             | [E-CF] |
| `6`   | Centered.                                                 | [E-CF] |
| `7`   | Right aligned.                                            | [E-CF] |
| `8`   | Italian hypenation.                                       | [E-CF] |


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


### `Q`: Select Editing Extent (SEE)

Format: `CSI {p} Q`

Establishes the editing extent for the subsequent character or line insertion or deletion. Different values of `{p}` affect the shifted part, typically in the presentation component. The default value of `{p}` is 0.

| `{p}` | Description                                                                      | Source |
|-------|----------------------------------------------------------------------------------|--------|
| `0`   | Limit to the active page.                                                        | [E-CF] |
| `1`   | Limit to the active line.                                                        | [E-CF] |
| `2`   | Limit to the active field.                                                       | [E-CF] |
| `3`   | Limit to the active qualified field.                                             | [E-CF] |
| `4`   | Shifted part consists of the relevant part of the entire presentation component. | [E-CF] |


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


Alternative Output, Printing
----------------------------

| Code                 | Description                                                                          | Default | Source |
|----------------------|--------------------------------------------------------------------------------------|---------|--------|
| `CSI {p} SP J`       | (PFS: Page Format Selection) Set the paper size for text. *See below.*               | `0`     | [E-CF] |
| `CSI {p} SP P`       | (PPA: Page Position Absolute) Sets active data position and page. *See below.*       | `1`     | [E-CF] |
| `CSI {p} SP Q`       | (PPR: Page Position Forward) Sets active data position and page. *See below.*        | `1`     | [E-CF] |
| `CSI {p} SP R`       | (PPB: Page Position Backward) Sets active data position and page. *See below.*       | `1`     | [E-CF] |
| `CSI {p} SP X`       | (SPQR: Set Print Quality And Rapidity) Controls printer speed, quality. *See below.* | `0`     | [E-CF] |
| `CSI {l} ; {s} SP Y` | (SEF: Sheet Eject And Feed) Ejects a sheet and loads a new one. *See below.*         | `0;0`   | [E-CF] |
| `CSI {p} SP ]`       | (SDS: Start Directed String) Mark how a string is displayed. *See below.*            | `0`     | [E-CF] |
| `CSI {p} SP e`       | (SCO: Select Character Orientation) Rotate text. *See below.*                        | `0`     | [E-CF] |
| `CSI {p} ; {e} SP k` | (SCP: Select Character Path) Reverses flow of text. *See below.*                     | *none*  | [E-CF] |
| `CSI {p} [`          | (SRS: Start Reversed String) Marks the beginning of reversed text. *See below.*      | `0`     | [E-CF] |
| `CSI {n} \`          | (PTX: Parallel Texts) Controls display of parallel texts. *See below.*               | `0`     | [E-CF] |
| `CSI {p} h`          | (SM: Set Mode) Set receiving device mode. *See below.*                               | *none*  | [E-CF] |
| `CSI {p} i`          | (MC: Media Copy) Start a data transfer. *See below.*                                 | `0`     | [E-CF] |
| `CSI {p..} l`        | (RM: Reset Mode) Set receiving device mode. *See below.*                             | *none*  | [E-CF] |


### `SP J`: Page Format Selection (PFS)

Format: `CSI {p} SP J`

Establishes the available area for the imaging of pages of text based on paper size. The pages are introduced by the subsequent occurrence of Form Feed characters in the data stream. The default is `0`.

| `{p}` | Description                           | Source |
|-------|---------------------------------------|--------|
| `0`   | Tall basic text communication format. | [E-CF] |
| `1`   | Wide basic text communication format. | [E-CF] |
| `2`   | Tall basic A4 format.                 | [E-CF] |
| `3`   | Wide basic A4 format.                 | [E-CF] |
| `4`   | Tall North American letter format.    | [E-CF] |
| `5`   | Wide North American letter format.    | [E-CF] |
| `6`   | Tall extended A4 format.              | [E-CF] |
| `7`   | Wide extended A4 format.              | [E-CF] |
| `8`   | Tall North American legal format.     | [E-CF] |
| `9`   | Wide North American legal format.     | [E-CF] |
| `10`  | A4 short lines format.                | [E-CF] |
| `11`  | A4 long lines format.                 | [E-CF] |
| `12`  | B5 short lines format.                | [E-CF] |
| `13`  | B5 long lines format.                 | [E-CF] |
| `14`  | B4 short lines format.                | [E-CF] |
| `15`  | B4 long lines format.                 | [E-CF] |


### `SP P`: Page Position Absolute (PPA)

Format: `CSI {p} SP P`

Causes the active data position to be moved in the data component to the corresponding character position on the `{n}`th page.


### `SP Q`: Page Position Forward (PPB)

Format: `CSI {p} SP Q`

Causes the active data position to be moved in the data component to the corresponding character position on the `{n}`th following page.


### `SP R`: Page Position Backward (PPB)

Format: `CSI {p} SP R`

Causes the active data position to be moved in the data component to the corresponding character position on the `{n}`th preceding page.


### `SP X`: Set Print Quality And Rapidity (SPQR)

Format: `CSI {p} SP X`

Sets the speed and quality of the printer, which is inversely proportional. Faster means less quality. Defaults to `0`.

| `{p}` | Description                                          | Source |
|-------|------------------------------------------------------|--------|
| `0`   | Highest available print quality; lowest print speed. | [E-CF] |
| `1`   | Medium print quality; medium print speed.            | [E-CF] |
| `2`   | Lowest (draft) print quality; highest print speed.   | [E-CF] |


### `SP Y`: Sheet Eject and Feed (SEF)

Format: `CSI {l} ; {s} SP Y`

Ejects a sheet of paper from the printing device. Loads another sheet as specified by `{l}`. Puts the ejected sheet into the stacker designated by `{s}`. Defaults to `0;0`.

| `{p}` | Description              | Source |
|-------|--------------------------|--------|
| `0`   | Do not load a new sheet. | [E-CF] |
| `1`   | Load sheet from bin 1.   | [E-CF] |
| `2`   | Load sheet from bin 2.   | [E-CF] |
| ...   | ...                      | ...    |
| *n*   | Load sheet from bin *n*. | [E-CF] |

| `{s}` | Description             | Source |
|-------|-------------------------|--------|
| `0`   | No stacker specified.   | [E-CF] |
| `1`   | Eject into stacker 1.   | [E-CF] |
| `2`   | Eject into stacker 2.   | [E-CF] |
| ...   | ...                     | ...    |
| *n*   | Eject into stacker *n*. | [E-CF] |


### `SP ]`: Start Directed String (SDS)

Format: `CSI {p} SP ]`

Mark the beginning and end of a string and designate if the string should be displayed forwards or backwards. Defaults to `0`.

| `{p}` | Description | Source |
|---|---|---|
| `0` | End of a directed string. Restore the previous direction. | [E-CF] |
| `1` | Start of a directed string. Set direction as left to right. | [E-CF] |
| `2` | Start of a directed string. Set direction as right to left. | [E-CF] |

Far more notes are explained in [E-CF], section 8.3.114.


### `SP e`: Select Character Orientation (SCO)

Format: `CSI {p} SP e`

Changes the amount of rotation for the following characters. Default value of `{p}` is 0.

| `{p}` | Description  | Source |
|-------|--------------|--------|
| `0`   | 0 degrees.   | [E-CF] |
| `1`   | 45 degrees.  | [E-CF] |
| `2`   | 90 degrees.  | [E-CF] |
| `3`   | 135 degrees. | [E-CF] |
| `4`   | 180 degrees. | [E-CF] |
| `5`   | 225 degrees. | [E-CF] |
| `6`   | 270 degrees. | [E-CF] |
| `7`   | 315 degrees. | [E-CF] |


### `SP k`: Select Character Path (SCP)

Format: `CSI {p} ; {e} SP k`

`{p}` determines the flow of characters when layout is left to right or top to bottom. `{e}` describes the effect. When `{e}` is non-zero, both the presentation and data components move their active position to the first character positions. There is no default value.

| `{p}` | Description                              | Source |
|-------|------------------------------------------|--------|
| `1`   | Normal (left to right / top to bottom)   | [E-CF] |
| `2`   | Reversed (right to left / bottom to top) | [E-CF] |

| `{e}` | Description                                                                          | Source |
|-------|--------------------------------------------------------------------------------------|--------|
| `0`   | Undefined, implementation dependent.                                                 | [E-CF] |
| `1`   | Update active line in presentation component to match active line in data component. | [E-CF] |
| `2`   | Update active line in data component to match active line in presentation component. | [E-CF] |


### `[`: Start Reversed String (SRS)

Format `CSI {p} [`

Indicates the start and the end of a string in a direction that is opposite to what's currently established. The string follows the preceding text and character progression is not affected. Nested strings are allowed, including Start Directed String. Defaults to `0`.

| `{p}` | Description                                                   | Source |
|-------|---------------------------------------------------------------|--------|
| `0`   | End of a reversed string. Reestablish the previous direction. | [E-CF] |
| `1`   | Beginning of a reversed string. Reverse the direction.        | [E-CF] |

Many more notes are available at [E-CF], section 8.3.137.


### `\`: Parallel Texts (PTX)

Format: `CSI {n} \`

Delimits strings of graphic characters that are communicated one after another in the data stream but that are intended to be presented in parallel with one another, usually in adjacent lines. The default is `0`.

| `{p}` | Description                                                          | Source |
|-------|----------------------------------------------------------------------|--------|
| `0`   | End of parallel texts.                                               | [E-CF] |
| `1`   | Beginning of a string of principal parallel text.                    | [E-CF] |
| `2`   | Beginning of a string of supplementary parallel text.                | [E-CF] |
| `3`   | Beginning of a string of supplementary Japanese phonetic annotation. | [E-CF] |
| `4`   | Beginning of a string of supplementary Chinese phonetic annotation.  | [E-CF] |
| `5`   | End of a string of supplementary phonetic annotations.               | [E-CF] |

There's significantly more detail in [E-CF], section 8.3.99 regarding this code.


### `h`: Set Mode (SM)

Format: `CSI {p} h`

Sets the mode of the receiving device to value indicated by `{p}`. Does not have a default value.

| `{p}` | Description                           | Source |
|-------|---------------------------------------|--------|
| `1`   | Guarded Area Transfer Mode (GATM).    | [E-CF] |
| `2`   | Keyboard Action Mode (KAM).           | [E-CF] |
| `3`   | Control Representation Mode (CRM).    | [E-CF] |
| `4`   | Insertion Replacement Mode (IRM).     | [E-CF] |
| `5`   | Status Report Transfer Mode (SRTM).   | [E-CF] |
| `6`   | Erasure Mode (ERM).                   | [E-CF] |
| `7`   | Line Editing Mode (VEM).              | [E-CF] |
| `8`   | Bidirectional Support Mode (BDSM).    | [E-CF] |
| `9`   | Device Component Select Mode (DCSM).  | [E-CF] |
| `10`  | Character Editing Mode (HEM).         | [E-CF] |
| `11`  | Positioning Unit Mode (PUM).          | [E-CF] |
| `12`  | Send/receive Mode (SRM).              | [E-CF] |
| `13`  | Format Effector Action Mode (FEAM).   | [E-CF] |
| `14`  | Format Effector Transfer Mode (FETM). | [E-CF] |
| `15`  | Multiple Area Transfer Mode (MATM).   | [E-CF] |
| `16`  | Transfer Termination Mode (TTM).      | [E-CF] |
| `17`  | Selected Area Transfer Mode (SATM).   | [E-CF] |
| `18`  | Tabulation Stop Mode (TSM).           | [E-CF] |
| `19`  | *Shall not be used.*                  | [E-CF] |
| `20`  | *Shall not be used.*                  | [E-CF] |
| `21`  | Graphic Rendition Combination (GRCM). | [E-CF] |
| `22`  | Zero Default Mode (ZDM).              | [E-CF] |


### `i`: Media Copy (MC)

Format: `CSI {p} i`

Start a data transfer to/from an auxiliary output/input device or to enable/disable the relay of the received data stream to/from an auxiliary output/input device. `{p}` defaults to `0`.

| `{p}` | Description                                       | Source |
|-------|---------------------------------------------------|--------|
| `0`   | Start transfer to a primary auxiliary device.     | [E-CF] |
| `1`   | Start transfer from a primary auxiliary device.   | [E-CF] |
| `2`   | Start transfer to a secondary auxiliary device.   | [E-CF] |
| `3`   | Start transfer from a secondary auxiliary device. | [E-CF] |
| `4`   | Stop transfer to a primary auxiliary device.      | [E-CF] |
| `5`   | Stop transfer from a primary auxiliary device.    | [E-CF] |
| `6`   | Stop transfer to a secondary auxiliary device.    | [E-CF] |
| `7`   | Stop transfer from a secondary auxiliary device.  | [E-CF] |


### `l`: Reset Mode (RM)

Format: `CSI {p..} l`

Causes the receiving device to reset its mode as specified by the values of `{p}`. There is no default value.

Private modes may be implemented using private parameters.

| `{p}` | Description                                | Source |
|-------|--------------------------------------------|--------|
| `1`   | Guarded area transfer mode (GATM).         | [E-CF] |
| `2`   | Keyboard action mode (KAM).                | [E-CF] |
| `3`   | Control representation mode (CRM).         | [E-CF] |
| `4`   | Intersection replacement mode (IRM).       | [E-CF] |
| `5`   | Status report transfer mode (SRTM).        | [E-CF] |
| `6`   | Erasure mode (ERM).                        | [E-CF] |
| `7`   | Line editing mode (VEM).                   | [E-CF] |
| `8`   | Bidirectional support mode (BDSM).         | [E-CF] |
| `9`   | Device component select mode (DCSM).       | [E-CF] |
| `10`  | Character editing mode (HEM).              | [E-CF] |
| `11`  | Positioning unit mode (PUM).               | [E-CF] |
| `12`  | Send/receive mode (SRM).                   | [E-CF] |
| `13`  | Format effector action mode (FEAM).        | [E-CF] |
| `14`  | Format effector transfer mode (FETM).      | [E-CF] |
| `15`  | Multiple area transfer mode (MATM).        | [E-CF] |
| `16`  | Transfer termination mode (TTM).           | [E-CF] |
| `17`  | Selected area transfer mode (SATM).        | [E-CF] |
| `18`  | Tabulation stop mode (TSM).                | [E-CF] |
| `19`  | Shall not be used.                         | [E-CF] |
| `20`  | Shall not be used.                         | [E-CF] |
| `21`  | Graphic rendition combination mode (GRCM). | [E-CF] |
| `22`  | Zero default mode (ZDM).                   | [E-CF] |


Sources
-------

* E-CF: [ECMA's Control Functions For Coded Character Sets][E-CF]
* E-CS: [ECMA's 8-Bit Single-Byte Coded Graphic Character Sets][E-CS]
* W-CC: [Wikipedia's C0 and C1 control codes][W-CC]
* W-GA: [Wikipedia's Grave Accent][W-GA]

[E-CF]: http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-048.pdf
[E-CS]: https://www.ecma-international.org/publications/files/ECMA-ST/Ecma-114.pdf
[W-CC]: https://en.wikipedia.org/wiki/C0_and_C1_control_codes
[W-GA]: https://en.wikipedia.org/wiki/Grave_accent

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
https://invisible-island.net/xterm/ctlseqs/ctlseqs.html
readkey bpm library

* Wikipedia's [ANSI Escape Code](https://en.wikipedia.org/wiki/ANSI_escape_code)
https://github.com/doy/runes/blob/master/doc/all-escapes.txt
