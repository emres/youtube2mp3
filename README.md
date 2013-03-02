# youtube2mp3: A very simple system to download YouTube music videos and convert them to mp3 files

This is a very simple and short Bash script to provide a GUI for downloading
YouTube music videos and convert them to MP3 files. I developed this for my
personal use (and to help a few friends) and then thought it would be helpful to
others, too. So here it is.

The script currently depends on zenity/kdialog, youtube-dl and ffmpeg. I have
tested it on Ubuntu GNU/Linux machines.

## How to Install

- Install packages (debian/ubuntu): `aptitude install ffmpeg libav-tools youtube-dl zenity lame`
- Install packages (archlinux):     `pacman -S ffmpeg youtube-dl zenity lame`
- Run `sudo ./install.sh`

Alternatively you can simply make youtube2mp3.sh executable and then run:

`./youtube2mp3.sh`

on the command line (or create a shortcut to it for easier access).

## Help
```html
Usage: youtube2mp3.sh [args]
    Runs in interactive mode if no args are given
        (dialog boxes will prompt for input)
    Runs in non-interactive mode if any args are given

    args = --url="<url>" |
           --odir=<odir> |
           --rate=<rate> |
           --ffmpeg |
           --vkeep |
           --help

    args may be given in any order
      url must be given (enclose <url> in quotes)
      odir defaults to current directory
      rate defaults to 256
      --vkeep: keeps downloaded video file (default is to delete)
      --avconv: use avconv converter, not ffmpeg
      --help: emits this message
```

## ScreenShot

Here's a [screenshot](https://raw.github.com/emres/youtube2mp3/master/img/screenshot_full.png) :

![youtube2mp3 screenshot](https://raw.github.com/emres/youtube2mp3/master/img/screenshot_thumbs.png "youtube2mp3 screen shot")

## Credits

Installation system and bitrate selection support has been added by
[PTKDev](https://github.com/PTKDev). See
[BashScript-YouTube2mp3](https://github.com/PTKDev/BashScript-YouTube2mp3) for more details.

Help system and downloaded video file support has been added by Joel Wittenberg <joel.wittenberg@gmail>

kdialog feature added by [Fran Quinto](https://github.com/fquinto).

Progress bar support for Zenity by [Tomáš Hnyk (felagund)](https://github.com/felagund).