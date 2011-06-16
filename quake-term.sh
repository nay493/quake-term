#!/bin/bash

if [ $(wmctrl -l | grep -c quake-term) -ne 0 ] 
then
	if [ -f ~/.quake-term.shaded ]
	then
		rm ~/.quake-term.shaded
		wmctrl -r 'quake-term' -b remove,shaded
		wmctrl -r 'quake-term' -b add,maximized_horz
		wmctrl -a 'quake-term' 
	else
		touch ~/.quake-term.shaded
		wmctrl -r 'quake-term' -b add,shaded
	fi

else
	rm ~/.quake-term.shaded
	# gnome-terminal --title=quake-term --role=quake-term --profile="quake-term"
	terminator -Tquake-term &
	while [ $(wmctrl -l | grep -c quake-term) -eq 0 ]
	do
		sleep .1
	done
	wmctrl -r 'quake-term' -b add,maximized_horz
	wmctrl -r 'quake-term' -b add,above
	wmctrl -r 'quake-term' -b add,skip_taskbar
	wmctrl -r 'quake-term' -b add,skip_pager
	wmctrl -r 'quake-term' -b add,sticky

fi


