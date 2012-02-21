#!/bin/bash
find_window_id()
{
  id=$(wmctrl -lx | grep "terminator\.Terminator.*${WINDOW_NAME}$" | cut -f1 -d' ')
  echo $id
}

get_window_id()
{
  if [ -f $WINDOW_STATE_FILE ]
	then
  	id=$(cut -f1 -d: $WINDOW_STATE_FILE)
		wmctrl_line=$(wmctrl -lx | grep "^${id}")
    if [ -z "$wmctrl_line" ]
		then
			id=''
		fi

	else
		id=''
	fi
  echo $id 
}

get_window_state()
{
 	state=$(cut -f2 -d: $WINDOW_STATE_FILE)
	echo $state
}

save_state_file()
{
  id=$1
	state=$2
	echo "Writing state file $WINDOW_STATE_FILE $id:$state"
	echo "$id:$state" > $WINDOW_STATE_FILE
}

launch()
{
  echo "Launching $WINDOW_NAME"
	$TERMINATOR -T"$WINDOW_NAME" &
	while [ "X$(find_window_id)" == "X" ]
	do
		sleep .1
	done
  
  id=$(find_window_id)
  echo "Decorating $WINDOW_NAME $id"
	wmctrl -i -r $id -b add,above
	wmctrl -i -r $id -b add,skip_taskbar
	wmctrl -i -r $id -b add,skip_pager
	wmctrl -i -r $id -b add,sticky
	wmctrl -i -r $id -b add,maximized_horz
	show $id
}

hide()
{
  id=$(get_window_id)
  echo "Hiding $WINDOW_NAME $id"
  save_state_file $id 'hidden'
  xdotool windowminimize $id
}

show()
{
  id=$1
  echo "Showing $WINDOW_NAME $id"
  save_state_file $id "visible"
  xdotool windowactivate $id
	xdotool windowfocus $id
	wmctrl -i -r $id -e 0,$X,$Y,$WIDTH,$HEIGHT
}

toggle()
{
  id=$1
  echo "Toggling $WINDOW_NAME $id"
	state=$(get_window_state)
  if [ $state == "visible" ]; then
    hide $id
  else
    show $id
  fi
}

DEFAULT_HEIGHT=300
HEIGHT=${1:-$DEFAULT_HEIGHT}
WIDTH=${2:-0}
X=${3:-0}
Y=${4:-0}

if [ $HEIGHT -lt $DEFAULT_HEIGHT ]
then
	HEIGHT=$DEFAULT_HEIGHT
fi

WINDOW_NAME='-quake-term-'
TERMINATOR="terminator -b --role=${WINDOW_NAME}"
WINDOW_STATE_FILE="$HOME/.shaded.$WINDOW_NAME"

WINDOW_ID=$(get_window_id)
echo "Window ID: $window_id"

if [ -z "$WINDOW_ID" ]
then
  launch
else
  toggle $WINDOW_ID
fi

