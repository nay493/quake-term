#!/bin/bash

get_window_id()
{
  id=$(wmctrl -lx | grep "terminator\.Terminator.*${WINDOW_NAME}$" | cut -f1 -d' ')
  echo $id
}

launch()
{
  echo "Launching $WINDOW_NAME"
	rm -f $WINDOW_STATE_FILE >/dev/null 2>&1
	$TERMINATOR -T"$WINDOW_NAME" &
	while [ "X$(get_window_id)" == "X" ]
	do
		sleep .1
	done

  id=$(get_window_id)
  echo "Decorating $WINDOW_NAME $id"
	wmctrl -i -r $id -b add,maximized_horz
	wmctrl -i -r $id -b add,above
	wmctrl -i -r $id -b add,skip_taskbar
	wmctrl -i -r $id -b add,skip_pager
	wmctrl -i -r $id -b add,sticky
}

hide()
{
  id=$1
  echo "Hiding $WINDOW_NAME $id"
  touch $WINDOW_STATE_FILE
  wmctrl -i -r $id -b add,shaded
}

show()
{
  id=$1
  echo "Showing $WINDOW_NAME $id"
  rm -f $WINDOW_STATE_FILE >/dev/null 2>&1
  wmctrl -i -r $id -b remove,shaded
  wmctrl -i -r $id -b add,maximized_horz
  wmctrl -i -a $id 
}

toggle()
{
  id=$1
  echo "Toggling $WINDOW_NAME $id"
  if [ ! -f $WINDOW_STATE_FILE ]; then
    hide $id
  else
    show $id
  fi
}

WINDOW_NAME='-quake-term-'
TERMINATOR="terminator --role=${WINDOW_NAME}"
WINDOW_STATE_FILE="$HOME/.shaded.$WINDOW_NAME"

window_id=$(get_window_id)
if [ "X$window_id" == "X" ]
then
  launch
else
  toggle $window_id
fi

