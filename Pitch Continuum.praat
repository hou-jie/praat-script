clearinfo

# constant
minpitch = 80

ramponset = 1 
#in sec
onramptime = 0.02
	
rampoffset = 1 
offramptime = 0.02
	
#choose linear or cosine ramp
linear = 1

choice_intensity = 1
intensity_level = 2

beginPause: "Parameters of the continuum..."
comment: "Enter the number of steps:"
	integer: "num_step", 9
	choice: "choice_intensity", choice_intensity
		option:	"Intensity profile of the source sound."
		option: "Intensity profile of the target sound."
		option: "Mean intensity profile of the two sounds."
		option: "Use a neutralized intensity profile."
	choice: "intensity_level", intensity_level
		option: "65 dB"
		option: "70 dB"
		option: "75 dB"
clicked = endPause: "Cancel", "OK", 2, 1

if clicked = 1
	exitScript()
endif

#'0' means to manipulate the selected portion of the pitch trajectory
whole_sound = 0

pause Select the source sound
Copy... Source
Scale intensity... 70
source_name$ = selected$("Sound")
select Sound 'source_name$'
total_duration = Get total duration
onset_time = 0
offset_time = total_duration
onset_time_source = onset_time
offset_time_source = offset_time

select Sound 'source_name$'
To Pitch... 0 75 600
Interpolate
Rename... 'source_name$'_interpolated
pitch_source = selected("Pitch")
select pitch_source

f0_tem = 0
while f0_tem < 1
	f0_tem = Get value at time... 'onset_time' Hertz Nearest
	if f0_tem = undefined
	    f0_tem = 0
	    onset_time = onset_time + 0.005
         endif
endwhile

f0_tem = 0
while f0_tem < 1
	f0_tem = Get value at time... 'offset_time' Hertz Nearest
	if f0_tem = undefined
	    f0_tem = 0
	    offset_time = offset_time - 0.005
         endif
endwhile
#pause 'onset_time' 'offset_time'

duration = (offset_time - onset_time)
portion = duration / 20
for i from 1 to 21
	time_point = onset_time + portion * (i-1)
	duration_source[i] = time_point
	pitch_source[i] = Get value at time... 'time_point' Hertz Nearest
endfor

pause Select the target sound
Copy... Target
Scale intensity... 70
target_name$ = selected$("Sound")
select Sound 'target_name$'
total_duration = Get total duration
onset_time = 0
offset_time = total_duration

select Sound 'target_name$'
To Pitch... 0 75 600
Interpolate
Rename... 'target_name$'_interpolated
pitch_target = selected("Pitch")
select pitch_target

f0_tem = 0
while f0_tem < 1
	f0_tem = Get value at time... 'onset_time' Hertz Nearest
	if f0_tem = undefined
	    f0_tem = 0
	    onset_time = onset_time + 0.005
         endif
endwhile

f0_tem = 0
while f0_tem < 1
	f0_tem = Get value at time... 'offset_time' Hertz Nearest
	if f0_tem = undefined
	    f0_tem = 0
	    offset_time = offset_time - 0.005
         endif
endwhile

duration = (offset_time - onset_time)
portion = duration / 20
for i from 1 to 21
	time_point = onset_time + portion * (i-1)
	pitch_target[i] = Get value at time... 'time_point' Hertz Nearest
	adjust_amount[i] = (pitch_target[i] - pitch_source[i])/(num_step-1)
endfor

select Sound 'source_name$'
To Manipulation... 0.01 50 350
select Manipulation 'source_name$'
Edit

for step from 1 to num_step
	editor Manipulation 'source_name$'
	Select... onset_time_source offset_time_source
	Remove pitch point(s)
	for i from 1 to 21
		Add pitch point at... duration_source[i]   pitch_source[i]+adjust_amount[i]*(step-1)
	endfor

	Publish resynthesis
	endeditor
endfor

for step from 1 to num_step
	select Sound fromManipulationEditor
	stimulus_num = num_step-step+1
	Rename... stimulus_'stimulus_num'
endfor

for step from 1 to num_step
	select Sound stimulus_'step'
	To Intensity... minpitch 0 yes
	Down to IntensityTier
	select Intensity stimulus_'step'
	mean = Get mean... 0 0 dB
	select IntensityTier stimulus_'step'
	Copy... flipped
	Formula... -(self-mean)
	select Sound stimulus_'step'
	plus IntensityTier flipped
	Multiply... no
	Rename... stimulus_'step'_flattened

	if choice_intensity = 1
		select Sound 'source_name$'
		To Intensity... minpitch 0 yes
		Down to IntensityTier
		plus Sound stimulus_'step'_flattened
		Multiply... yes 0.8	
		Rename... stimulus_'step'_final
		select Intensity 'source_name$'
		plus IntensityTier 'source_name$'
		plus Sound stimulus_'step'_flattened
		Remove
	elsif choice_intensity = 2
		select Sound 'target_name$'
		To Intensity... minpitch 0 yes
		Down to IntensityTier
		plus Sound stimulus_'step'_flattened
		Multiply... yes 0.8	
		Rename... stimulus_'step'_final
		select Intensity 'target_name$'
		plus IntensityTier 'target_name$'
		plus Sound stimulus_'step'_flattened
		Remove
	elsif choice_intensity = 3
		select Sound 'source_name$'
		To Intensity... minpitch 0 yes
		Down to IntensityTier
		numofTiers =  Get number of points

		select Sound 'target_name$'
		To Intensity... minpitch 0 yes
		Down to IntensityTier
		select IntensityTier 'target_name$'
		for numTier from 1 to  numofTiers
			temValue = Get value at index... 'numTier'
			if temValue = undefined
				tierTarget[numTier] = 0
			else
				tierTarget[numTier] = temValue
			endif
		endfor
		select IntensityTier 'source_name$'
		for numTier from 1 to  numofTiers
			temValue = Get value at index... 'numTier'
			if tierTarget[numTier] > 0
				newValue = (temValue + tierTarget[numTier])/2
				timeStamp = Get time from index...  'numTier'				
				Remove point... numTier 
				Add point... 'timeStamp' 'newValue'
			endif
		endfor
		plus Sound stimulus_'step'_flattened
		Multiply... yes 0.8	
		Rename... stimulus_'step'_final
		select Intensity 'target_name$'
		plus IntensityTier 'target_name$'
		plus Intensity 'source_name$'
		plus IntensityTier 'source_name$'
		plus Sound stimulus_'step'_flattened
		Remove
	else
		Rename... stimulus_'step'_final
	endif

	select Sound stimulus_'step'_final
	if ramponset = 1
	  if linear = 1
	    Formula... if x<onramptime  
	       ...then self * (x/onramptime) 
	       ...else self endif  
	  else
	    Formula... if x<('onramptime')  
		...then self * cos((x-'onramptime')/('onramptime') * pi/2)
		...else self endif  
	  endif
	endif

	endtime = Get end time
	if rampoffset = 1  
	  if linear = 1
	     Formula... if x>('endtime' - 'offramptime')  
     		...then self * (1-((x-endtime + 'offramptime')/'offramptime'))
		...else self endif   
	   else
	    Formula... if x>('endtime' - 'offramptime')  
		...then self * cos((x-(endtime - 'offramptime'))/'offramptime' * pi/2)
		...else self endif
	  endif
	endif

	if intensity_level = 1
		Scale intensity... 65
	elsif  intensity_level = 2
		Scale intensity... 70
	else
		Scale intensity... 75
	endif

	select Intensity stimulus_'step'
	plus IntensityTier stimulus_'step'
	plus  IntensityTier flipped
	Remove
endfor

select Pitch Source
plus Pitch Source_interpolated
plus Pitch Target
plus Pitch Target_interpolated
plus Manipulation Source
Remove