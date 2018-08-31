#!/bin/bash

BG_COLOR="black"
FG_COLOR="white"

#~ BG_COLOR="white"
#~ FG_COLOR="black"

#~ LANGUAGE="en"
#~ FILES="DB/$LANGUAGE/i3wm_configuration.txt XxX DB/$LANGUAGE/i3wm_default_shortcuts.txt"
#~ IMAGE="DB/image/i3wm.png"
#~ NAME="i3wm"

#~ LANGUAGE="fr"
##~ FILES="DB/$LANGUAGE/bash_1.txt"
#~ FILES="DB/$LANGUAGE/QUIZ_BASH_1_3"
#~ IMAGE="DB/image/bash.png"
#~ NAME="quiz_bash_1_3"

LANGUAGE="fr"
FILES="DB/$LANGUAGE/i3wm_1"
IMAGE="DB/image/i3wm.png"
NAME="i3wm_1"

mkdir Wallpaper/$LANGUAGE/$NAME 2> /dev/null

NB_LINES=`cat $FILES | wc -l`

# SCREEN_W=1366; SCREEN_H=768
#~ SCREEN_W=1920; SCREEN_H=1080
# SCREEN_W=800; SCREEN_H=600
# SCREEN_W=1024; SCREEN_H=768

SCREEN_W=$1; SCREEN_H=$2

#BASE 10,10 for 800x600
margin_top=`expr $SCREEN_H / 60`
margin_left=`expr \( $SCREEN_W / 80 \) / 2`

#ONE LINE IS 25px + margin ?
#MAX_LINES=

limit_height_image=`expr $SCREEN_H / 3`

x=$margin_left
y=0

if [ ! "$IMAGE" == "" ]; then
  convert "$IMAGE" -resize x${limit_height_image} tmpIM
  IMAGE_WIDTH=`identify -format '%w' tmpIM`
  IMAGE_HEIGHT=`identify -format '%h' tmpIM`

  half_image=`expr $IMAGE_WIDTH / 2`
fi

MAX_LINES=30
if [ $NB_LINES -gt $MAX_LINES ];  then #TWO COLUMNS
  line_width=`expr \( $SCREEN_W / 2 \) - $margin_left - $margin_left` #MArgin left / right
  line_height=`expr $SCREEN_H / $MAX_LINES`
else
  line_width=`expr $SCREEN_W - $margin_left - $margin_left - $margin_left`
  line_height=`expr \( $SCREEN_H - $IMAGE_HEIGHT - $margin_top \) / \( $NB_LINES + 2 \) ` # +5 lines
fi
im_X=`expr ${line_width} / 2 - $half_image`


echo $NB_LINES
echo $pointsize

rm wallpaper.jpg 2> /dev/null

i_line=0
cat $FILES | while read line; do
  if [ ! "$IMAGE" == "" ]; then #IF WALLPAPER HAVE IMAGE
    y=`expr $limit_height_image + $margin_top`
    IMAGE=""
  fi
  varL=$(echo $line | cut -f1 -d:)
  varR=$(echo $line | cut -f2 -d:)
  y=`expr $y + ${line_height}`
  i_line=`expr $i_line + 1`
  if [ "$i_line" == "$MAX_LINES" ] || [ "$line" == "XxX" ]; then
    x=`expr $line_width + $margin_left + $margin_left` #MARGIN LEFT
    y=$margin_top
    i_line=0
    #change line width with more margin-right
    line_width=`expr $line_width - $margin_left - $margin_left`
  fi
  x_margin=`expr $x + $margin_left`
  if [ ! "$line" == "XxX" ]; then
	if [ ! "$line" == "" ]; then
		echo " --> ${line_width}x${line_height}   /   +${x_margin}+${y}" >&2
		convert -fill "$FG_COLOR" -background "$BG_COLOR" pango:"<span foreground='white'>${varL}</span>     <span foreground='yellow'>${varR}</span>" -page +${x_margin}+${y} miff:-
	else
		convert -fill "$FG_COLOR" -background "$BG_COLOR" -size "${line_width}x${line_height}" -page +${x_margin}+${y} label:"" miff:-
	fi
  fi
done | convert -size ${SCREEN_W}x${SCREEN_H} xc:$BG_COLOR - -flatten wallpaper.jpg
#CAN TEST WITH white background

convert wallpaper.jpg tmpIM -geometry +${im_X}+${margin_top} -composite Wallpaper/$LANGUAGE/$NAME/${SCREEN_W}x${SCREEN_H}.jpg
#rm wallpaper.jpg
#rm tmpIM

# feh --bg-scale out.jpg
# viewnior ${SCREEN_W}x${SCREEN_H}.jpg &

#convert -gravity center pango:@pango_test.txt  pango_test.png
# -gravity $gravity -size ${width}x -background $BG_COLOR
