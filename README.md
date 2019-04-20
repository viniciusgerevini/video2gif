# video2gif

a dockerised helper for converting videos to gif using ffmpeg and gifsicle.

## Command options 

```text
video2gif [OPTIONS] [input file]


-s, --size         size. e.g 600x400. Default: same as video size
-o, --output       output file name. Default: [input].gif.
-i, --input        input file.
-ts, --start-time  time position from video to start gif. Seconds or HH:mm:ss. Default: start of the video
-te, --end-time    time position from video to stop gif. Seconds or HH:mm:ss. Default: end of the video
-h, --help         print help message.
-v, --version      print version.
-d, --gif-frame-duration   delay/duration of each Gif frame in hundredths of a second. Default: 3.
-fr, --video-frame-rate    video frame rate. Less frames generate smaller gifs. Used by ffmpeg. Default: 10.
```
Note: 

-s, -fr, -ts and -te are used by ffmpeg, possible values on: [https://ffmpeg.org/ffmpeg.html#toc-Video-Options]

-d is used by gifsicle, possible values on: [https://www.lcdf.org/gifsicle/man.html]


## Installation and usage

To **install** or **update** video2gif use cURL or Wget:

cURL
```sh
# bash
curl -o- https://raw.githubusercontent.com/viniciusgerevini/video2gif/1.2.1/install.sh | bash

# zsh
curl -o- https://raw.githubusercontent.com/viniciusgerevini/video2gif/1.2.1/install.sh | zsh
```

Wget:
```sh
# bash
wget -qO- https://raw.githubusercontent.com/viniciusgerevini/video2gif/1.2.1/install.sh | bash

# zsh
wget -qO- https://raw.githubusercontent.com/viniciusgerevini/video2gif/1.2.1/install.sh | zsh
```

This script will install and add a video2gif alias to your profile configuration.

video2gif will try to use your local `ffmpeg` and `gifsicle` if installed, otherwise it will download the proper docker image on the first run.

```sh
video2gif --help
```

## Examples:

creates gif from 2:45 to 3:00
```sh
video2gif --starting-time 2:45 --end-time 3:00 input.mov
#or
video2gif -ts 2:45 -te 3:00 input.mov
```

create gif with size of 300x100
```sh
video2gif -s 300x100 input.mpeg
```

create gif with less frames (as a side effect you get smaller file size)
```sh
video2gif -fr 5 input.mov
```
