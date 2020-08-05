#!/usr/bin/env bash

thisdir=$(dirname $0)

DIR="$thisdir/dl/"
if [ ! -d "$DIR" ]; then
  mkdir "$thisdir/dl"
fi

help()
{
   # Display Help
   echo "YouTube Video Converter Script Version 0.5b"
   echo "This Script uses ffmpeg and youtube-dl, to download and convert a Video from youtube to the mp4 format. The downloaded video is stored under the dl directory. It will not be deleted if you don't use the -r option."
   echo "Usage: pr0verter <URL> <Options>"
   echo "Example: pr0verter https://www.youtube.com/watch?v=dQw4w9WgXcQ -d 30 -o output.mp4"
   echo
   echo "Options:"
   echo "-R resolution sets the resolution of the output video"
   echo "-s n          the converted video will start at n seconds"
   echo "-d n          the converted video will durate n seconds, default is 60"
   echo "-f n          the converted video will have the size of around n mb, default is 10mb"
   echo "-o filepath   the output video will be saved under filepath" 
   echo "-a bitrate    the output video will have kbitrate Audiobitrate in kBit/s, default is 128"
   echo "-r            removes the downloaded file after conversion"
   echo "-h            displays this help menu"
   echo
}

if [ $# -lt 2 ]; then
help
exit 1
fi

link=$1
shift

# information about duration and id
iddur=$(youtube-dl --get-filename $link -o "%(id)s %(duration)s")

#filename of downloaded file 
ytdlfilename=$( echo "$iddur" | cut -d ' ' -f1) 

#initial values
start=0
duration=$( echo "$iddur" | cut -d ' ' -f2) 
durationset=0
outputsize=10 #mb
audiobitrate=128 #kBit/s
output="$thisdir/$ytdlfilename.mp4"
deleteafterconversion=0
res=0
resset=0



#option and values parsin
while [ "$1" != "" ]; do
	case $1 in
        -s | --start )          shift
                                start=$1
                                ;;
        -r | --remove-after-conversion )
                                deleteafterconversion=1
                                ;;
         -R | --resolution )    shift
								res=$1
								resset=1
                                ;;                       

        -d | --duration )       shift
								duration=$1
								durationset=1
                                ;;
                                
		-o | --output )			shift
								output=$1
								;;
								
		-f | --filesize )		shift
								outputsize=$1
								;;
								
		-a | --audio-bitrate )  shift
								outputsize=$1
								;;
								
        -h | --help )           help
                                exit
                                ;;
                                
        * )                     help
                                exit 1
    esac
    shift
done

#calculate duration to end of video if duration is not set 
if [ $durationset -eq 0 ]; then
duration=$(( $duration-$start ))
fi;

#download the video to dl folder
youtube-dl -o "$thisdir/dl/%(id)s" "$link"

#get the filename with .mp4/.mkv ending
finalname=$( ls $thisdir/dl | grep "$ytdlfilename" | head -n 1 )


# set the parameter for ffmpeg
param1=""
param2=""
param3=""

if [ $start -gt 0 ]; then
param1="-ss $start "
fi;

if [ $durationset -gt 0 ]; then 
param2="-t $duration "
fi;

if [ $resset -gt 0 ]; then
param3="-s $res"
fi;

#calculate the bitrate
targetbitrate=$(($outputsize*8192/($duration+2))) #kBit/s # duration - 2 to  make the file a little bit smaller than the sizelimit
videobitrate=$(($targetbitrate-$audiobitrate))

input="$thisdir/dl/$finalname"

ffmpeg -y -i $input $param1 $param2 $param3 -c:v libx264 -b:v ${videobitrate}k -pass 1 -an -f null /dev/null && \
ffmpeg -i $input $param1 $param2 $param3 -c:v libx264 -b:v ${videobitrate}k -pass 2 -c:a aac -b:a ${audiobitrate}k $output

if [ $deleteafterconversion -gt 0 ]; then
rm $thisdir/dl/$finalname
fi;

