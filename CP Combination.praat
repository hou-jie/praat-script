# ---------- ---------- ---------- ---------- ----------
# CP Combination.praat
# Version 2.0
# Praat 6.0.49
# 
# Author: Jie Hou
# Date: 2019.09.16
# ---------- ---------- ---------- ---------- ----------

# ! Input Variable
  sound_pre_name$ = ""
  interval_name$ = "ISI"

# PART 1  same-same pairs

 x = 1
 
 for i from 1 to 11

  z1$ = string$(x)

  if x<10
    x$ = "0"+z1$
   else
    x$ = string$(x)
  endif


 Read from file... 'sound_pre_name$''x$'.wav
 Read from file... 'interval_name$'.wav
 Concatenate

 select Sound 'sound_pre_name$''x$'
   plus Sound 'interval_name$'
 Remove
 select Sound chain
 Rename... chain0

 Read from file... 'sound_pre_name$''x$'.wav

 select Sound chain0
   plus Sound 'sound_pre_name$''x$'
 Concatenate
 select Sound chain
 Save as WAV file... 'x$''x$'.wav

 select all
 Remove

  x = x+1

 endfor


# PART 2  same-different pairs / 2-steps / normal order

 x = 1
 y = 3

 for i from 1 to 9

  z1$ = string$(x)
  z2$ = string$(y)

  if x<10
    x$ = "0"+z1$
   else
    x$ = string$(x)
  endif

  if y<10
    y$ = "0"+z2$
   else
    y$ = string$(y)
  endif


 Read from file... 'sound_pre_name$''x$'.wav
 Read from file... 'interval_name$'.wav
 Read from file... 'sound_pre_name$''y$'.wav

 select Sound 'sound_pre_name$''x$'
  plus Sound 'interval_name$'
  plus Sound 'sound_pre_name$''y$'
 Concatenate

 select Sound chain
 Save as WAV file... 'x$''y$'.wav

 select all
 Remove

 x = x+1
 y = y+1

 endfor


# PART 3  same-different pairs / 2-steps / reversed order

 x = 1
 y = 3

 for i from 1 to 9

  z1$ = string$(x)
  z2$ = string$(y)

  if x<10
    x$ = "0"+z1$
   else
    x$ = string$(x)
  endif

  if y<10
    y$ = "0"+z2$
   else
    y$ = string$(y)
  endif


 Read from file... 'sound_pre_name$''y$'.wav
 Read from file... 'interval_name$'.wav
 Read from file... 'sound_pre_name$''x$'.wav

 select Sound 'sound_pre_name$''y$'
  plus Sound 'interval_name$'
  plus Sound 'sound_pre_name$''x$'
 Concatenate

 select Sound chain
 Save as WAV file... 'y$''x$'.wav

 select all
 Remove

 x = x+1
 y = y+1

 endfor
