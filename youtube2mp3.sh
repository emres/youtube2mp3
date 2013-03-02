#!/bin/bash
#    Copyright (C) 2012  Emre Sevinç - http://ileriseviye.org/blog
#	 Forked by PTKDev <ptkdev@gmail.com> - http://www.ptkdev.it/
#    Modified August 2012 by Joel Wittenberg <joel.wittenberg@gmail>
#    Modified (kdialog feature) January 2013 by Fran Quinto <fran.quinto <at> gmail>
#
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


PROGNAME=`basename $0`

function help()
{
	echo
	echo "Usage: $PROGNAME [args]"
	echo "    Runs in interactive mode if no args are given"
	echo "        (dialog boxes will prompt for input)"
	echo "    Runs in non-interactive mode if any args are given"
	echo
	echo "    args = --url=\"<url>\" |"
	echo "           --odir=<odir> |"
	echo "           --rate=<rate> |"
	echo "           --${alt_conv} |"
	echo "           --vkeep |"
	echo "           --help"
	echo
	echo "    args may be given in any order"
	echo "      url must be given (enclose <url> in quotes)"
	echo "      odir defaults to current directory"
	echo "      rate defaults to $dflt_bitrate"
	echo "      --vkeep: keeps downloaded video file (default is to delete)"
	echo "      --${alt_conv}: use ${alt_conv} converter, not ${dflt_conv}"
	echo "      --help: emits this message"
	echo
}

function zenity_cancel()
{
	local l_op=$1
	zenity --title="$var_title" --info\
		--text="Operation [$l_op] cancelled"
}

function kdialog_cancel()
{
	local l_op=$1
	kdialog --msgbox "Operation [$l_op] cancelled" --title="$var_title"
}

function zenity_address()
{
	local l_addrprompt="Enter Youtube address:"
	address=$(zenity --width=600 --height=150\
			--entry\
			--title="$var_title"\
			--text="$l_addrprompt")
	local l_retstat=$?
	if [ $l_retstat -ne 0 ]; then
		zenity_cancel "Get URL"
		exit $l_retstat
	fi
}

function kdialog_address()
{
	local l_addrprompt="Enter Youtube address:"
	address=$(kdialog\
		--title="$var_title"\
		--inputbox "$l_addrprompt" "" 600 150)
	local l_retstat=$?
	if [ $l_retstat -ne 0 ]; then
		kdialog_cancel "Get URL"
		exit $l_retstat
	fi
}

function zenity_dir()
{
	local l_dirprompt="Select the destination directory for your MP3 file:"
	dest_dir="$(zenity --title="$var_title"\
			 --file-selection --directory\
			 --text="$l_dirprompt")"
	local l_retstat=$?
	if [ $l_retstat -ne 0 ]; then
		zenity_cancel "Get Output Directory"
		exit $l_retstat
	fi
}

function kdialog_dir()
{
	local l_dirprompt="Select the destination directory for your MP3 file:"
	dest_dir="$(kdialog --title="$var_title $l_dirprompt "\
			 --getexistingdirectory *;)"
	local l_retstat=$?
	if [ $l_retstat -ne 0 ]; then
		kdialog_cancel "Get Output Directory"
		exit $l_retstat
	fi
}

function zenity_bitrate()
{
	bitrate=$(zenity\
		  --title="$var_title"\
		  --list\
		  --text="Select MP3 Bitrate"\
		  --radiolist  --column "Pick"\
		  --column "Bitrate" FALSE 128 FALSE 192 TRUE 256 FALSE 320)
	local l_retstat=$?
}

function kdialog_bitrate()
{
	bitrate=$(kdialog --title="$var_title" --radiolist "Select MP3 Bitrate" 128 "128" off 192 "192" off 256 "256" on;)
	local l_retstat=$?
}

function zenity_keepvideo()
{
	zenity\
		--question\
		--title="$var_title"\
		--text="Do you want to keep the video file?"
	delete_video=$?
}

function kdialog_keepvideo()
{
	kdialog\
		--title="$var_title"\
		--yesno "Do you want to keep the video file?"
	delete_video=$?
}

function zenity_mp3ready()
{
	zenity --width=260\
		--height=130\
		--title="$var_title"\
		--info\
		--text="Your MP3 file is ready."
}

function kdialog_mp3ready()
{
	kdialog\
		--title="$var_title"\
		--msgbox "Your MP3 file is ready."
}

function zenity_error()
{
	zenity --error\
		--text="$err"
}

function kdialog_error()
{
	kdialog\
		--title="$var_title"\
		--error "$err"
}

function get_video_convert_extract()
{
	local l_vidid=${1}
	l_vidid=$(echo $l_vidid | cut -d'&' -f1)
	local l_vidtitle="$(youtube-dl --get-title $address)"

	# replace spawn-of-satan-whitespace with dashes
	l_vidtitle="$(echo $l_vidtitle | tr '[:blank:]' -)"

    ${dnload} $address | stdbuf -i0 -o0 -e0 tr '\r' '\n' | stdbuf -i0 -o0 -e0 grep -e 'download.*ETA' | stdbuf -i0 -o0 -e0 sed -e 's/.download. //' | stdbuf -i0 -o0 -e0 sed -e 's/%.*//' | stdbuf -i0 -o0 -e0 sed -e 's/\..*//' | stdbuf -i0 -o0 -e0 sed -e 's/ *//' | zenity --progress --text="Downloading the video file from YouTube..." --auto-close --percentage=0


	if [ -e "${l_vidid}".flv ]; then
		ext="flv"
	fi

	if [ -e "${l_vidid}".mp4 ]; then
		ext="mp4"
	fi

	if [ -e "${l_vidid}".webm ]; then
		ext="webm"
	fi

	${avconv} -i "${l_vidid}".$ext /tmp/"${l_vidtitle}".wav
	${audenc} /tmp/"${l_vidtitle}".wav\
			"$dest_dir"/"${l_vidtitle}".mp3\
			-b $bitrate

	# rm the converted video file
	rm /tmp/"$l_vidtitle".wav

	if [ $delete_video -gt 0 ]; then
		# rm the downloaded video file
		rm "${l_vidid}".$ext
	else
		# move the downloaded video file to the output dir
		# and use a more meaningful title for the video file
		mv "${l_vidid}".$ext "$dest_dir"/"${l_vidtitle}".$ext
	fi
}

#
# Script execution starts here
#

var_title="YouTube MP3 Extractor"

# default is to delete the downloaded video file
delete_video=1

# Check env for use Gnome (zenity) or Kde (kdialog)
# Info here:
#             http://enzotib.blogspot.com.es/
#             http://askubuntu.com/questions/72549/determine-what-window-manager-or-desktop-is-running
if [ "$DESKTOP_SESSION" = "kde-plasma" ]; then
   windows=kdialog
else
   windows=zenity
fi

# avconv is a replacement for ffmpeg
# I default to avconv simply because my main distros are
# ubuntu-based, and these distros have moved to avconv.
#
# If you prefer ffmpeg to be the default then just change the if test
if [ 1 -eq 1 ]; then
	dflt_conv=ffmpeg
	alt_conv=avconv
else
	dflt_conv=avconv
	alt_conv=ffmpeg
fi
avconv=${dflt_conv}

dnload="youtube-dl"
audenc=lame

if [ $# -gt 0 ]; then
  interactive=0
  have_url=0

  # arg defaults
  dest_dir="$(pwd)"
  dflt_bitrate=256
  bitrate=$dflt_bitrate

  for arg in "$@"
  do
	case $arg in
	(--help)
		help
		exit 0
		;;

	(--url=*)
		address="${arg:6}"
		have_url=1
		;;

	(--odir=*)
		dest_dir="${arg:7}"
		;;

	(--rate=*)
		bitrate=${arg:7}
		case $bitrate in
			(128 |\
			 192 |\
			 256 |\
			 320)
				;;
			(*)
				if [ 1 -eq 0 ]; then
				  # invalid bitrate, query user for new rate
				  zenity_bitrate
				else
				  # just set to a valid value
				  echo -n "$PROGNAME:"
				  echo -n " Invalid rate \"$bitrate\","
				  echo " defaulting to $dflt_bitrate"
				  bitrate=$dflt_bitrate
				fi
				;;
		esac
		;;

	(--vkeep)
		delete_video=0
		;;

	(--${alt_conv})
		avconv=$alt_conv
		;;

	(--*)
		echo
		echo "$PROGNAME: Invalid option given: \"$arg\""
		help
		exit -3
		;;

	(*)
		echo
		echo "$PROGNAME: Invalid parameter given: \"$arg\""
		help
		exit 10
		;;
	esac
  done

  if [ $have_url -eq 0 ]; then
	echo
	echo "$PROGNAME: ERROR: url required"
	help
	exit 1
  fi
else
	interactive=1
	bitrate=0
	address="please-supply-an-address"

	${windows}_address
	${windows}_dir
	${windows}_bitrate
	${windows}_keepvideo
fi

# youtube urls have 'v=' followed by a unique id

regex='v=(.*)'
if [[ $address =~ $regex ]]; then
	get_video_convert_extract ${BASH_REMATCH[1]}

	if [ $interactive -gt 0 ]; then
		${windows}_mp3ready
	else
		echo
		echo "$PROGNAME: Done."
		echo
	fi
else
	err="Invalid YouTube URL: please correct and retry ..."

	if [ $interactive -gt 0 ]; then
		${windows}_error
	else
		echo "$PROGNAME: $err"
	fi
fi
