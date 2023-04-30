# ---------- ---------- ---------- ---------- ----------
# GetPitchandFormants.praat
# 
# This script prints the F0 values and F1 to F3
# 
# Mr. Jie Hou
# 2016.08.02
# ---------- ---------- ---------- ---------- ----------

# Extract file name
soundN$=selected$("Sound")

a= Get begin of selection
b= Get end of selection
d= 0
        dianNum= 11
        c=('b'-'a')/('dianNum'-1)
       time= 'a'
       for i from 1 to 'dianNum'
          Move cursor to... 'time'
          f_0=Get pitch
          f_1=Get first formant
          f_2=Get second formant
          f_3=Get third formant

          #resultline$ ='time:8''tab$''f_0:2''tab$''f_1:2''tab$''f_2:2'
        #fileappend "'textfile$'" 'resultline$'
         printline  'tab$''soundN$''tab$''d''tab$''time:8''tab$''f_0:2''tab$''f_1:2''tab$''f_2:2''tab$''f_3:2'
        time='time'+'c'
        d=d+1

        endfor
  
# save the results of time pitch and formant values
 fappendinfo 'soundN$'.txt
 clearinfo
