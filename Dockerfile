FROM alpine:edge

WORKDIR /tmp

RUN apk --no-cache add ffmpeg gifsicle

COPY ./video2gif /usr/bin/video2gif

ENTRYPOINT ["video2gif"]
CMD ["-h"]
