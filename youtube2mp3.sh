#!/bin/bash

address=$(zenity --width=600 --height=150 --entry --title="YouTube MP3 Extractor" --text "Enter Youtube address (then click OK and then select the destination directory for your MP3 file):")
return_code=$?
regex='v=(.*)'
dest_dir=$(zenity --file-selection --directory)
if [[ $return_code -eq 0 ]]; then
	if [[ $address =~ $regex ]]; then
		video_id=${BASH_REMATCH[1]}
		video_id=$(echo $video_id | cut -d'&' -f1)
		video_title="$(youtube-dl --get-title $address)"
		youtube-dl $address

		if [ -e $video_id.flv ]; then
			ext="flv"
		fi

		if [ -e $video_id.mp4 ]; then
			ext="mp4"
		fi

		ffmpeg -i $video_id.$ext /tmp/"$video_title".wav
		lame /tmp/"$video_title".wav $dest_dir/"$video_title".mp3
		rm $video_id.$ext /tmp/"$video_title".wav

	    zenity --width=260 --height=130 --title "YouTube MP3 Extractor" --info --text "Your MP3 file is ready."
	else
		zenity --error --text "Sorry but the system encountered a problem. Please check your YouTube address and try again later..."
	fi
fi