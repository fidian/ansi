#!/bin/bash
######################################################################
# Silly dice thingy...
######################################################################
pip=o
p0="       "
p1=" $pip     "
p2="   $pip   "
p3="     $pip "
p4=" $pip   $pip "
p5=" $pip $pip $pip "
 
cs=$(ansi --save-cursor)        ## save cursor position 
cr=$(ansi --restore-cursor)     ## restore cursor position 
dn=$(ansi --down=1)             ## move down 1 line 
b=$(ansi --bold)                ## set bold attribute 
cu_put='ansi --position=%d=%d'  ## format string to position cursor 
 
dice=( 
  "$b$cs$p0$cr$dn$cs$p0$cr$dn$cs$p2$cr$dn$cs$p0$cr$dn$p0" 
  "$b$cs$p0$cr$dn$cs$p1$cr$dn$cs$p0$cr$dn$cs$p3$cr$dn$p0" 
  "$b$cs$p0$cr$dn$cs$p1$cr$dn$cs$p2$cr$dn$cs$p3$cr$dn$p0" 
  "$b$cs$p0$cr$dn$cs$p4$cr$dn$cs$p0$cr$dn$cs$p4$cr$dn$p0" 
  "$b$cs$p0$cr$dn$cs$p4$cr$dn$cs$p2$cr$dn$cs$p4$cr$dn$p0" 
  "$b$cs$p0$cr$dn$cs$p5$cr$dn$cs$p0$cr$dn$cs$p5$cr$dn$p0" 
  ) 

clear 
ansi --bell

ansi --position=2,5
ansi --bg-white --black "${dice[RANDOM%6]}"
 
ansi --position=2,20
ansi --bg-black --white "${dice[RANDOM%6]}"

echo -ne
exit 0
