#!/bin/bash

address=$(zenity --width=600 --height=150 --entry --title="YouTube MP3 Extractor" --text "Youtube address:")
return_code=$?
regex='v=(.*)'
if [[ $return_code -eq 0 ]]; then
	if [[ $address =~ $regex ]]; then
		video_id=${BASH_REMATCH[1]}
		video_id=$(echo $video_id | cut -d'&' -f1)
		video_title="$(youtube-dl --get-title $address)"
		youtube-dl $address
		ffmpeg -i $video_id.flv "$video_title".wav
		lame "$video_title".wav "$video_title".mp3
		rm $video_id.flv
		rm "$video_title".wav
	else
		zenity --error --text "A problem had been encountered."
	fi
fi
