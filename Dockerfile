FROM alpine:3.16.0

RUN apk add ffmpeg

COPY build/linux/x64/release/bundle/ .

RUN chmod +x osumffmpeg
