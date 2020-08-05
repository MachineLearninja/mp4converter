## YouTube Video Converter Script Version 0.5b

This Script uses **ffmpeg** and **youtube-dl**, to download and convert a Video from youtube to the mp4 format. The downloaded video is stored under the dl directory. It will not be deleted if you don't use the -r option.

Usage: ``` ./converter.sh [URL] [Options]``` <br>
Example: ```./converter.sh https://www.youtube.com/watch?v=dQw4w9WgXcQ -d 30 -o output.mp4```<br>


Options:<br>
-R resolution sets the resolution of the output video<br>
-s n          the converted video will start at n seconds<br>
-d n          the converted video will durate n seconds<br>
-f n          the converted video will have the size of around n MB, default is 10MB<br>
-o filepath   the output video will be saved under filepath<br>
-a bitrate    the output video will have kbitrate Audiobitrate in kBit/s, default is 128<br>
-r            removes the downloaded file after conversion<br>
-h            displays this help menu<br>
