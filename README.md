# video2gif

a dockerised helper for converting video to gif using ffmpeg and gifsicle.

```sh
docker run --rm -v $(pwd):/tmp vgerevini/video2gif input.mov
```

## Command options 

```text
-s, --size         size. e.g 600x400. Default: same as video size
-o, --output       output file name. Default: [input].gif.
-i, --input        input file.
-ts, --start-time  time position from video to start gif. Seconds or HH:mm:ss. Default: start of the video
-te, --end-time    time position from video to stop gif. Seconds or HH:mm:ss. Default: end of the video
-h, --help         print help message.
-v, --version      print version.
  
#extra options: 
-fr, --video-frame-rate    video frame rate. Used by ffmpeg. Default: 10.
-d, --gif-frame-duration   delay/duration of each Gif frame in hundredths of a second. Default: 3.
```

Note: 

-s, -fr, ts and te are used on ffmpeg, possible values on: [https://ffmpeg.org/ffmpeg.html#toc-Video-Options]

-d is used on gifsicle, possible values on: [https://www.lcdf.org/gifsicle/man.html]

## Usage

### Using the docker image 

```sh
docker run --rm -v $(pwd):/tmp vgerevini/video2gif -o output.gif input.mov
```
__pro__: Hassle free. Just run the command and everything is fine.

__caveat__: as your current directory is mounted inside the docker image you can't use locations that are not nested in your current folder as input or output.

_tip: to avoid having to type the whole command everytime you can create an alias in your terminal:_
```sh
alias video2gif='docker run --rm -v $(pwd):/tmp vgerevini/video2gif'
```

### Using your local ffmpeg and gifsicle

If you already have ffmpeg and gifsicle installed in your system and you prefer to use them instead of a docker image you can copy the script located on `./lib/video2gif`. It should work with no problems on Linux and MacOS.

## Examples:

creates gif from 2:45 to 3:00
```sh
video2gif --starting-time 2:45 --end-time 3:00 input.mov
#or
video2gif -ts 2:45 -te 3:00 input.mov
```

create gifs for multiple inputs with size of 300x100
```sh
video2gif -s 300x100 input1.mov input2.mpeg input3.mov
```


