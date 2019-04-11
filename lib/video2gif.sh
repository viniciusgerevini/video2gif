#!/bin/sh
set -e

delay_between_frames=3
frame_rate=10

get_output_filename() {
  local file=$1
  local filename="${file##*/}"
  echo "${filename%%.*}.gif"
}

print_usage() {
  echo ""
  echo "usage:"
  echo "  video2gif input.mov"
  echo "  video2gif -s 900x600 input.mov"
  echo "  video2gif -o output.gif input.mov"
  echo "  video2gif -o out.gif -s 900x600 -d 3 -r 10 input.mov"
  echo "options:"
  echo "  -o    output filename. Default: [input].gif"
  echo "  -s    size. e.g 600x400. Default: same as video size"
  echo "  -d    delay between frames in hundredths of a second. Default: 3"
  echo "  -r    video frame rate. Default: 10"
}

print_help() {
  echo "video2gif"
  echo "converts video to gif using ffmpeg and gifsicle"

  print_usage
}

while getopts ":s:o:d:h" opt; do
  case $opt in
    s)
      output_size=$OPTARG
      ;;
    o)
      output_filename=$OPTARG
      ;;
    d)
      delay_between_frames=$OPTARG
      ;;
    r)
      frame_rate=$OPTARG
      ;;
    h)
      print_help
      exit 0
      ;;
    \?)
      echo "invalid option: -$OPTARG" >&2
      print_usage
      exit 1
      ;;
    :)
      echo "option -$OPTARG requires an argument." >&2
      print_usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

if [ -z "$@" ]
then
  print_help
  exit 1
fi

for file in "$@"
do
  echo $output_filename
  if [ -z "$output_filename" ]
  then
    output_filename=$(get_output_filename $file)
  fi

  if [ -n "$output_size" ]
  then
    output_size_parameter="-s $output_size"
  fi

  echo "Converting $file"
  ffmpeg -i $file $output_size_parameter -r $frame_rate -f gif - | \
  gifsicle --optimize=3 --delay=$delay_between_frames > $output_filename
done

