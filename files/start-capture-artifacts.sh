#!/bin/bash

sessionId=$1
if [ -z $sessionId ]; then
  echo "[warn] [CaptureArtifacts] No sense to record artifacts as sessionId not detected!"
  exit 0
fi

echo "[info] [CaptureArtifacts] sessionId: $sessionId"

# send signal to start streaming of the screens from device
echo "[info] [CaptureArtifacts] trying to send 'on': nc ${BROADCAST_HOST} ${BROADCAST_PORT}"
echo -n "on" | nc ${BROADCAST_HOST} ${BROADCAST_PORT} -w 0 -v

echo "[info] [CaptureArtifacts] generating video file ${sessionId}.mp4..."
# you can add `-v trace` to enable verbose mode logs
ffmpeg -f mjpeg -r 10 -i tcp://${BROADCAST_HOST}:${BROADCAST_PORT} -vf scale="-2:720" -vcodec libx264 -y ${FFMPEG_OPTS} /tmp/${sessionId}.mp4 > ${VIDEO_LOG} 2>&1 &

exit 0
