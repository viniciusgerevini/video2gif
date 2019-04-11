#!/bin/sh
set -e

delay_between_frames=3
frame_rate=10
version="1.0.0"

get_output_filename() {
  local file=$1
  local filename="${file##*/}"
  echo "${filename%%.*}.gif"
}

print_usage() {
  echo ""
  echo "usage: video2gif [options] <input file>"
  echo ""
  echo "examples:"
  echo "  video2gif input.mov"
  echo "  video2gif -s 900x600 input.mov"
  echo "  video2gif -o output.gif input.mov"
  echo "  video2gif -o out.gif -i input.mov"
  echo "  video2gif --start-time 00:20:00 --end-time 10 input.mov"
  echo ""
  echo "options:"
  echo "  -s, --size     size. e.g 600x400. Default: same as video size"
  echo "  -o, --output   output file name. Default: [input].gif."
  echo "  -i, --input    input file."
  echo "  -ts, --start-time  time from video to start gif. Seconds or HH:mm:ss. Default: start of the video"
  echo "  -te, --end-time    time (relative to start time) to stop gif. Seconds or HH:mm:ss. Default: end of the video"
  echo "  -h, --help     print this help message."
  echo "  -v, --version  print version."
  echo ""
  echo "extra options: "
  echo "  -fr, --video-frame-rate    video frame rate. Used by ffmpeg. Default: 10."
  echo "  -d, --gif-frame-duration   delay/duration of each Gif frame in hundredths of a second. Default: 3."
  echo ""
}

print_help() {
  echo "video2gif"
  echo "converts video to gif using ffmpeg and gifsicle"

  print_usage
}

print_version() {
  echo "video2gif $version"
}

check_argument() {
  if [ -z "$2" ]
  then
    echo "value for '$1' not provided" >&2
    exit 1
  fi
}

while [ "$#" -gt 0 ]
do
  case "$1" in
    -h|--help)
      print_help
      exit 0
      ;;
    -v|--version)
      print_version
      exit 0
      ;;
    -i|--input)
      input_file="$2"
      check_argument $1 $2
      shift
      shift
      ;;
    -o|--output)
      output_file="$2"
      check_argument $1 $2
      shift
      shift
      ;;
    -s|--size)
      output_size="$2"
      check_argument $1 $2
      shift
      shift
      ;;
    -d|--gif-frame-duration)
      delay_between_frames="$2"
      check_argument $1 $2
      shift
      shift
      ;;
    -fr|--video-frame-rate)
      frame_rate="$2"
      check_argument $1 $2
      shift
      shift
      ;;
    -ts|--start-time)
      start_time="$2"
      check_argument $1 $2
      shift
      shift
      ;;
    -te|--end-time)
      gif_duration="$2"
      check_argument $1 $2
      shift
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Invalid option '$1'." >&2
      print_usage
      exit 1
      ;;
    *) break;;
  esac
done

if [ "$#" -eq 0 ] && [ -z "$input_file" ]
then
  echo "input not provided" >&2
  echo ""
  print_help
  exit 1
fi

if [ -n "$input_file" ]
then
  input_files="$input_file $@"
else
  input_files=$@
fi

if [ "$#" -gt 1 ] && [ -n "$output_file" ]
then
  echo "you can't set output name when more than one input provided" >&2
  echo ""
  exit 1
fi

for file in $input_files
do
  if [ -z "$output_file" ]
  then
    output_filename=$(get_output_filename $file)
  else
    output_filename=$output_file
  fi

  if [ -n "$output_size" ]
  then
    output_size_parameter="-s $output_size"
  fi

  if [ -n "$start_time" ]
  then
    start_time_parameter="-ss $start_time"
  fi

  if [ -n "$gif_duration" ]
  then
    gif_duration_parameter="-t $gif_duration"
  fi

  echo "converting $file to $output_filename..."

  ffmpeg $start_time_parameter -i $file $output_size_parameter -r $frame_rate -f gif $gif_duration_parameter - | \
  gifsicle --optimize=3 --delay=$delay_between_frames > $output_filename

  echo ""
  echo -e "SUCCESS: $file converted"
  echo ""
done

