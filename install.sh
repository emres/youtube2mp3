#!/bin/sh
#youtube2mp3
#    Copyright (C) 2012  Emre Sevinç - http://ileriseviye.org/blog
#	 Forked by PTKDev <ptkdev@gmail.com> - http://www.ptkdev.it/
#    Modified August 2012 by Joel Wittenberg <joel.wittenberg@gmail>
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

if [ ! -d "/usr/share/icons/gnome/scalable/apps/" ]; then
mkdir /usr/share/icons/gnome/scalable/apps/
fi
if [ ! -d "/opt/youtube2mp3/" ]; then
mkdir /opt/youtube2mp3/
fi

if [ -a "/usr/share/icons/gnome/scalable/apps/youtube.png" ]; then
rm /usr/share/icons/gnome/scalable/apps/youtube.png
fi
if [ -a "/opt/youtube2mp3/youtube2mp3.sh" ]; then
rm /opt/youtube2mp3/youtube2mp3.sh
fi
if [ -a "/usr/share/applications/YouTube\ Downloader.desktop" ]; then
rm /usr/share/applications/YouTube\ Downloader.desktop
fi

cp ./img/youtube.png /usr/share/icons/gnome/scalable/apps/
cp youtube2mp3.sh /opt/youtube2mp3/
cp YouTube\ Downloader.desktop /usr/share/applications

exit
