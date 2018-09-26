#!/bin/bash
#MANUAL : Avoid long lines
#MANUAL : Prepare logo position top right
#< 12 lines : bigger font, logo top middle and text will be lower
#> 12 lines : logo top right

image_position="top_right"
SUBJECT="i3wm"
NUMBER="1"

LANGUAGE="fr"
FILES="DB/$LANGUAGE/$SUBJECT/_${NUMBER}.txt"
IMAGE="DB/image/$SUBJECT.png"
NAME="${SUBJECT}_${NUMBER}"
mkdir Wallpaper/$LANGUAGE/$NAME 2> /dev/null

BG_COLOR="black"
FG_COLOR="white"

NB_LINES=`cat $FILES | wc -l`

SCREEN_W=$1
SCREEN_H=$2

#BASE 10,10 for 800x600
margin_top=`expr $SCREEN_H / 60`
margin_left=`expr \( $SCREEN_W / 80 \) / 2`

limit_height_image=`expr $SCREEN_H / 3`

x=$margin_left
y=0

if [ ! "$IMAGE" == "" ]; then
  convert "$IMAGE" -resize x${limit_height_image} tmpIM
  IMAGE_WIDTH=`identify -format '%w' tmpIM`
  IMAGE_HEIGHT=`identify -format '%h' tmpIM`

  half_image=`expr $IMAGE_WIDTH / 2`
fi

MAX_LINES=24
if [ $NB_LINES -gt $MAX_LINES ];  then #TWO COLUMNS
  line_width=`expr \( $SCREEN_W / 2 \) - $margin_left - $margin_left` #MArgin left / right
  line_height=`expr $SCREEN_H / $MAX_LINES`
elif [ $NB_LINES -lt 12 ]; then
  image_position="top_middle"
  line_width=`expr $SCREEN_W - $margin_left - $margin_left - $margin_left`
  line_height=`expr \( $SCREEN_H - $IMAGE_HEIGHT - $margin_top \) / \( $NB_LINES + 2 \) ` # +5 lines
  #~ line_height=`expr \( $SCREEN_H - $margin_top \) / \( $NB_LINES \) ` # +5 lines
else
  line_width=`expr $SCREEN_W - $margin_left - $margin_left - $margin_left`
  #~ line_height=`expr \( $SCREEN_H - $IMAGE_HEIGHT - $margin_top \) / \( $NB_LINES + 2 \) ` # +5 lines
  line_height=`expr \( $SCREEN_H - $margin_top \) / \( $NB_LINES \) ` # +5 lines
fi
im_X=`expr ${line_width} / 2 - $half_image`


echo " $NAME - ${SCREEN_W}x${SCREEN_H}"
echo " NB_LINES = $NB_LINES"
#~ echo $pointsize

rm wallpaper.jpg 2> /dev/null


FONT_SIZE=20000
if [ $NB_LINES -lt 12 ]; then
	case $2 in
		1080) FONT_SIZE=30000 ;;
		1024) FONT_SIZE=30000 ;;
		900)  FONT_SIZE=25000 ;;
		768)  FONT_SIZE=25000 ;;
	esac
else
	case $2 in
		1080) FONT_SIZE=25000 ;;
		1024) FONT_SIZE=25000 ;;
		900)  FONT_SIZE=20000 ;;
		768)  FONT_SIZE=20000 ;;
	esac
fi

i_line=0
cat $FILES | while read line; do
  if [ ! "$IMAGE" == "" ]; then #IF WALLPAPER HAVE IMAGE
	#Pas de decalage en fonction de l'image
    if [ $NB_LINES -lt 12 ]; then
		y=`expr $limit_height_image + $margin_top`
    else
		y=0
    fi
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
		#~ echo " --> ${line_width}x${line_height}   /   +${x_margin}+${y}" >&2
		convert -fill "$FG_COLOR" -background "$BG_COLOR" -size "${line_width}x${line_height}" pango:"<span size='$FONT_SIZE' foreground='white'>${varL}</span>     <span size='$FONT_SIZE' foreground='yellow'>${varR}</span>" -page +${x_margin}+${y} miff:-
	else
		convert -fill "$FG_COLOR" -background "$BG_COLOR" -size "${line_width}x${line_height}" -page +${x_margin}+${y} label:"" miff:-
	fi
  fi
done | convert -size ${SCREEN_W}x${SCREEN_H} xc:$BG_COLOR - -flatten wallpaper.jpg
#CAN TEST WITH white background

#IMAGE TOP MIDDLE
#~ convert wallpaper.jpg tmpIM -geometry +${im_X}+${margin_top} -composite Wallpaper/$LANGUAGE/$NAME/${SCREEN_W}x${SCREEN_H}.jpg

#IMAGE TOP RIGHT
if [[ "$image_position" == "top_right" ]]; then
	#BIGGER MARGIN TOP AND RIGHT... x5 ?
	TMP_margin_top=$(expr $margin_top + $margin_top + $margin_top + $margin_top + $margin_top)
	LEFT_IM=$(expr $SCREEN_W - $IMAGE_WIDTH - $margin_top - $margin_top - $margin_top - $margin_top - $margin_top )
	echo "+ Position of image :  +${LEFT_IM}+${TMP_margin_top} (top_right)"
	convert wallpaper.jpg tmpIM -geometry +${LEFT_IM}+${TMP_margin_top} -composite Wallpaper/$LANGUAGE/$NAME/${SCREEN_W}x${SCREEN_H}.jpg
elif [[ "$image_position" == "top_middle" ]]; then
	echo "+ Position of image :  +${im_X}+${margin_top} (top_middle)"
	convert wallpaper.jpg tmpIM -geometry +${im_X}+${margin_top} -composite Wallpaper/$LANGUAGE/$NAME/${SCREEN_W}x${SCREEN_H}.jpg
fi

echo

#CLEAN UP
rm wallpaper.jpg
rm tmpIM

# feh --bg-scale out.jpg
# viewnior ${SCREEN_W}x${SCREEN_H}.jpg &

#convert -gravity center pango:@pango_test.txt  pango_test.png
# -gravity $gravity -size ${width}x -background $BG_COLOR
