FROM alpine:edge

WORKDIR /tmp

RUN apk --no-cache add ffmpeg gifsicle

COPY ./lib/video2gif.sh /usr/bin/video2gif

ENTRYPOINT ["video2gif"]
CMD ["-h"]
