#ROUTE!

unit mil
status_file $/SpecctraWithinLayout.STS
bestsave on $/SpecctraWithinLayout.WBEST

 tax cross 1.2
 tax squeeze .5

#################################
#### Initial Route phase

route 1
if (complete_wire < 100)
      then (clean 2)

#### Route phase 1
#
setexpr count (3)
	sh echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxDEBUG!
	sh echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxDEBUG!
	sh echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxDEBUG!
while (count >0 && complete_wire < 100) 
      (
      sh echo WHILE_LOOP!................................................................................................................................
       setexpr comp_rate (complete_wire)
       route 5 11
       if (complete_wire < 100 && complete_wire > comp_rate)
          then (
                setexpr count (count - 1)
               )
          else (setexpr count (0))
      )
#
#### Route phase 2
#
if (complete_wire < 100)
      then (clean 2)
setexpr count2 (5)
while (count2 >0 && complete_wire < 100) 
      (       
       setexpr comp_rate2 (complete_wire)
       route 5 16
       if (complete_wire > comp_rate2)
          then (
                setexpr count2 (count2 - 1)
               )
          else (
                setexpr count2 (0)
               )
      )
#
#### Route phase 3
#
if (complete_wire < 100)
      then (clean 3)
setexpr count3 (10)
while (count3 >0 && complete_wire < 100) 
      (       
       setexpr comp_rate3 (complete_wire)
       route 5 16
       if (complete_wire > comp_rate3)
          then (
                setexpr count3 (count3 - 1)
               )
          else (
                filter 5
                limit cross 0
                route 25 16
                setexpr count3 (0)
               )
      )
#
#### Final Cleanup
#
clean 5
#
# uncomment out the miter commands below to miter your corners
#
 unit mil
 miter (slant 1000)
 miter (pin 50)
 miter (bend 32 2)
#
write routes $/SpecctraWithinLayout.RTE
report status

