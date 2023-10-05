# Plex DVR Emulator (HLS)
This web server emulates a SiliconDust HDHomeRun by its HTTP API for use with Plex's DVR feature.
It is designed for use with HLS .m3u8 streams, although any input format accepted by `ffmpeg` should work.

### Features
- Multiple channels
- XMLTV file generation (it just creates a generic 24/7 programme for each available channel)

### Running
#### Docker Compose
```
---
version: '3.9'

services:
  plex-dvr-hls:
    image: ghcr.io/mhhplumber/plex-dvr-hls:latest
    container_name: plex-dvr-hls
    environment:
      - TZ=America/Los_Angeles # Timezone (important, this will affect the guide times)
      - PUID=1000 # User ID to run as
      - PGID=1000 # Group ID to run as
    volumes:
      - /host/path/to/config:/config
    ports:
      - 5004:5004 # API Port
    restart: unless-stopped
```
1. Add the server to the Plex DVR e.g. `http://<ip of machine>:5004`. When prompted for an Electronic Program Guide, you can either use one if it's available, or use the auto-generated one by entering `http://<ip of machine>:5004/xmltv`

#### CLI
```
docker create \
  --name=plex-dvr-hls \
  -e TZ=America/Los_Angeles`# Specify a timezone to use` \
  -e PUID=1000 `# User ID to run as` \
  -e PGID=1000 `# Group ID to run as` \
  -v /host/path/to/config:/config `# Contains all relevant configuration files.` \
  -p 5004:5004 `# API Port` \
  --restart unless-stopped \
  ghcr.io/mhhplumber/plex-dvr-hls:latest
```

### Configuration
The first time you run this container you will notice that `config.json` and `channels.json` files have been placed at the mount point of your config directory.

#### config.yaml
Your initial `config.json` should resemble this:
```
{
  "name": "Plex HLS Tuner",
  "encoder_profile": "cpu"
}
```
* `name` The name of your tuner - this is the name Plex will discover it as
* `encoder_profile` This is the encoder profile ffmpeg will use. Available options are are `vaapi`, `video_toolbox`, `omx` and `cpu`

#### channels.yaml
Your initial `channels.json` should resemble this:
```
[
  {
    "name": "NHK World",
    "url": "https://nhkwlive-xjp.akamaized.net/hls/live/2003458/nhkwlive-xjp-en/index_1M.m3u8"
  },
  {
    "name": "PGA Tour on CBS",
    "url": "http://cbssportsliveios-i.akamaihd.net/hls/live/207523/pgatour_simulcast/desktop.m3u8",
    "proxy": {
      "host": "proxy.somewhere.com:3128",
      "username": "",
      "password": ""
    }
  }
]
```
* `name` The channel name as you wish for it to appear.
* `url` The URL of the stream. Most times this will include `.m3u8` followed by 0 or more additional arguments

##### Proxy Settings
Some streams are geolocked or otherwise require use of a proxy in order to consume.
A proxy may be added to any channel as below:
```
  {
    "name": "PGA Tour on CBS",
    "url": "http://cbssportsliveios-i.akamaihd.net/hls/live/207523/pgatour_simulcast/desktop.m3u8",
    "proxy": {
      "host": "proxy.somewhere.com:3128",
      "username": "",
      "password": ""
    }
  }
```
* `host` the proxy host
* `username` your username for accessing the proxy
* `password` your password for accessing the proxy
