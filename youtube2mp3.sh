#!/bin/bash
#youtube2mp3
#    Copyright (C) 2012  PTKDev <ptkdev@gmail.com> - http://www.ptkdev.it/
#    This Project is Fork Of youtube2mp3 (https://github.com/emres/youtube2mp3)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

address=$(zenity --width=600 --height=150 --entry --title="YouTube MP3 Extractor" --text "Enter Youtube address (then click OK and then select the destination directory for your MP3 file):")
bitrate=$(zenity  --list  --text "YouTube MP3 Bitrate" --radiolist  --column "Pick" --column "Bitrate" TRUE 128 FALSE 192 FALSE 256 FALSE 320)
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

		if [ -e $video_id.webm ]; then
			ext="webm"
		fi

		ffmpeg -i $video_id.$ext /tmp/"$video_title".wav
		lame /tmp/"$video_title".wav "$dest_dir"/"$video_title".mp3 -b $bitrate
		rm $video_id.$ext /tmp/"$video_title".wav

	    zenity --width=260 --height=130 --title "YouTube MP3 Extractor" --info --text "Your MP3 file is ready."
	else
		zenity --error --text "Sorry but the system encountered a problem. Please check your YouTube address and try again later..."
	fi
fi
