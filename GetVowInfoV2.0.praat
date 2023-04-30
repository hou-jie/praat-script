# ---------- ---------- ---------- ---------- ----------
# GetVowelInfo.praat
# V2.0
# 
# 
# Mr. HOU Jie
# JAIST 2020.10.13
# ---------- ---------- ---------- ---------- ----------

form select directory
comment The path of the directory - choose from list:
    optionmenu dirName: 1
        option Choose from list
        option C:\test\
        option C:\test1\
        #option E:\OB-udd\graenser\data_indsamling\informant\
        #option E:\OB-udd\graenser\data_indsamling\inform_ufil\
comment or give the path - e.g. 'd:\sound\':
    text Directory_manual
endform

# If directory is chosen manually, select this directory
if length(directory_manual$) > 0
    dirName$ = directory_manual$
endif

Read Table from comma-separated file... 'dirName$'1.csv 
select Table 1
  numberOfFiles = Get number of rows
for ifile to numberOfFiles
select Table 1
  filename$ = Get value... 'ifile' 1
  vowel1$ = Get value... 'ifile' 2
  vowel2$ = Get value... 'ifile' 3
  
  sound_file$ = dirName$ + filename$ + ".wav"
  text_file$ = dirName$ + filename$ + ".TextGrid"


   # Open sound file
   Read from file... 'sound_file$'
   Read from file... 'text_file$'

#GetInfo
select Sound 'filename$'
plus TextGrid 'filename$'
Edit
editor TextGrid 'filename$'

Move cursor to... 0.0
Find... 'vowel1$'

a = Get start of selection
b = Get end of selection
 dianNum = 11
c = ('b'-'a')/('dianNum'-1)
 time = 'a'
       for i from 1 to 'dianNum'
          Move cursor to... 'time'
          f_0 = Get pitch
          f_1 = Get first formant
          f_2 = Get second formant
          f_3 = Get third formant
          f_4 = Get fourth formant
          frame = 'i' - 1
          #resultline$ ='time:8''tab$''f_0:2'
          #fileappend "'textfile$'" 'resultline$'
         printline 'filename$''tab$''vowel1$''tab$''frame''tab$''time:8''tab$''f_0:2''tab$''f_1:2''tab$''f_2:2''tab$''f_3:2''tab$''f_4:2'
         time='time'+'c'
        endfor
# 解决两个音节连在一起时 有概率造成后一个音节无法选中
x = Get cursor
Move cursor to... 'x' - 0.01
Find... 'vowel2$'

a = Get start of selection
b = Get end of selection
 dianNum = 11
c = ('b'-'a')/('dianNum'-1)
 time = 'a'
       for i from 1 to 'dianNum'
          Move cursor to... 'time'
          f_0 = Get pitch
          f_1 = Get first formant
          f_2 = Get second formant
          f_3 = Get third formant
          f_4 = Get fourth formant
          frame = 'i' - 1
          #resultline$ ='time:8''tab$''f_0:2'
      #fileappend "'textfile$'" 'resultline$'
         printline 'filename$''tab$''vowel2$''tab$''frame''tab$''time:8''tab$''f_0:2''tab$''f_1:2''tab$''f_2:2''tab$''f_3:2''tab$''f_4:2'
         time='time'+'c'
        endfor
        fappendinfo 'filename$'.txt
        clearinfo
endeditor  
   Remove
endfor

# End of loop that goes through all files
select Table 1
Remove
# save the results of time and pitch values
#fappendinfo 'dirName$'result.txt
clearinfo