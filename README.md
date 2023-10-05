# Plex DVR Emulator (HLS)
This web server emulates a SiliconDust HDHomeRun by its HTTP API for use with Plex's DVR feature. It is designed for use with HLS .m3u8 streams, although any input format accepted by `ffmpeg` should work.

### Features
- Multiple channels
- XMLTV file generation (it just creates a generic 24/7 programme for each available channel)

### Running
#### Docker Compose

Example:
```
---
version: '3.9'

services:
  plex-dvr-hls:
    image: ghcr.io/mhhplumber/plex-dvr-hls:latest
    container_name: plex-dvr-hls
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Los_Angeles
    volumes:
      - /home/plex-dvr-hls:/config
    ports:
      - 5004:5004
    restart: always
```
1. Add the server to the Plex DVR e.g. `http://<ip of machine>:5004`. When prompted for an Electronic Program Guide, you can either use one if it's available, or use the auto-generated one by entering `http://<ip of machine>:5004/xmltv`
