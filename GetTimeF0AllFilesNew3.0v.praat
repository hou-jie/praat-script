# ---------- ---------- ---------- ---------- ----------
# GetTimeandF0at11PointsforAllFiles.praat
# V3.0
#
# This script opens all sound files in a directory and
# TextGrid the sound wave and
# print the F0 values at 11 time points
#
# Mr. Jie Hou
# 2017.01.01
# ---------- ---------- ---------- ---------- ----------

form Open all sounds/Pitch-tiers in directory
comment The path of the directory - choose from list:
    optionmenu dirName: 1
        option Choose from list
        option C:\praat\
        option D:\test1\
        #option E:\OB-udd\graenser\data_indsamling\informant\
        #option E:\OB-udd\graenser\data_indsamling\inform_ufil\
comment or give the path - e.g. 'd:\sound\':
    text Directory_manual
    optionmenu Sound_format 1
        option .wav
        option .au
        option .aiff
        option .aifc
        option .Pitch   
endform

# If directory is chosen manually, select this directory
if length(directory_manual$) > 0
    dirName$ = directory_manual$
endif

# Change these values for different pitch settings
time_step =  0.01
min_pitch = 75
max_nb_cand = 15
silence = 0.03
voicing = 0.45
octave_cost = 0.01
oct_jump_cost = 0.35
voiced_cost = 0.14
max_pitch = 600

# lists all .wav files
soundNames$ = dirName$ +"*.wav"
Create Strings as file list... list 'soundNames$'

# Loop that goes through all .wav files
numberOfFiles = Get number of strings
for ifile to numberOfFiles
   select Strings list
   sound_file_name$ = Get string... ifile
   root_name$ = sound_file_name$ - ".wav"
   sound_file$ = dirName$ + sound_file_name$
   f0_file$ = dirName$ + root_name$ + ".txt"

   # Open sound file
   Read from file... 'sound_file$'

   # Calculate Pitch (autocorrelation method)
   To Pitch (ac)... 'time_step' 'min_pitch' 'max_nb_cand' no 'silence' 'voicing' 'octave_cost' 'oct_jump_cost' 'voiced_cost' 'max_pitch'

median_f0 = Get quantile... 0 0 0.5 Hertz
mean_period = 1/median_f0

select Sound 'root_name$'
plus Pitch 'root_name$'

To PointProcess (cc)
To TextGrid (vuv)... 0.02 mean_period
select PointProcess 'root_name$'_'root_name$'
Remove
select Sound 'root_name$'
plus TextGrid 'root_name$'_'root_name$'
Edit
pause Need any change?

select TextGrid 'root_name$'_'root_name$'
                vowel$ = Get label of interval... 1 2
                start = Get starting point... 1 2
        end = Get end point... 1 2
        duration = end - start
        #Select... start end                
Write to text file... 'dirName$''root_name$'.TextGrid
select TextGrid 'root_name$'_'root_name$'
#plus Pitch 'root_name$'
Remove
endeditor
select Sound 'root_name$'
Edit
editor Sound 'root_name$'
Select... 'start' 'end'

a= Get begin of selection
b= Get end of selection
        dianNum= 11
        c=('b'-'a')/('dianNum'-1)
       time= 'a'
       for i from 1 to 'dianNum'
          Move cursor to... 'time'
          f_0=Get pitch
          #resultline$ ='time:8''tab$''f_0:2'
          #fileappend "'textfile$'" 'resultline$'
         printline  'root_name$''tab$''vowel$''tab$''time:8''tab$''f_0:2'
        time='time'+'c'

        endfor
endeditor
  
   Remove
   select Pitch 'root_name$'
   Remove
endfor
# End of loop that goes through all files
select Strings list
Remove
# save the results of time and pitch values
fappendinfo 'dirName$'result.txt
clearinfo
