#!/bin/bash
for LANG in "fr" "en"; do
	for SUB in "i3wm" "bash"; do
		for NUM in {1..20}; do
			if [ -f "DB/$LANG/$SUB/_${NUM}.txt" ]; then
				./wallpaper_generator.sh 1920 1080 $LANG $SUB $NUM
				./wallpaper_generator.sh 1366 768 $LANG $SUB $NUM
				./wallpaper_generator.sh 1360 768 $LANG $SUB $NUM
				./wallpaper_generator.sh 1024 768 $LANG $SUB $NUM
				./wallpaper_generator.sh 1900 900 $LANG $SUB $NUM
				./wallpaper_generator.sh 1280 1024 $LANG $SUB $NUM
			fi
		done
	done
done
