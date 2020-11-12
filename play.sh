#!/bin/bash

VIDEO=/home/pi/Videos/Interstellar.mp4
#VIDEO=/home/pi/Videos/Arrival.mp4

IT8951=/home/pi/slowplayer/IT8951/IT8951

MAXCOUNT=$(ffprobe -show_streams $VIDEO 2>/dev/null | grep -F nb_frames | cut -d= -f2 | xargs printf %.0f)
COUNT=$(cat /home/pi/position)
let "MAXCOUNT*=30"
echo $COUNT/$MAXCOUNT

if [ $COUNT -lt $MAXCOUNT ]; then
	sudo $IT8951 0 0 0.bmp
	ffmpeg -ss $COUNT"ms" -y -i $VIDEO -vf "scale=h=600:w=800:force_original_aspect_ratio=increase,crop=w=800:h=600" -vframes 1 -s 800x600 1.bmp
	convert 1.bmp -level 0%,100%,1.7 -colorspace gray -ordered-dither o8x8 0.bmp	
	#convert 1.bmp -level 0%,100%,1.7 -colorspace gray -dither FloydSteinberg 0.bmp
        #convert 1.bmp \
	#	\( -clone 0 -channel RG -separate +channel -evaluate-sequence mean \) \
	#	\( -clone 0 -channel GB -separate +channel -evaluate-sequence mean \) \
	#	-delete 0 -evaluate-sequence mean -dither FloydSteinberg 0.bmp	
	let "COUNT+=30"
	echo $COUNT > /home/pi/position	
else
	echo 30 > /home/pi/position
fi
