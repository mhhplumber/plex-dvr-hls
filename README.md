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

#### config.json
Your initial `config.json` should resemble this:
```
{
  "name": "Plex HLS Tuner",
  "encoder_profile": "cpu"
}
```
* `name` The name of your tuner - this is the name Plex will discover it as
* `encoder_profile` This is the encoder profile ffmpeg will use. Available options are are `vaapi`, `video_toolbox`, `omx` and `cpu`

#### channels.json
Your initial `channels.json` should resemble this:
```
[
  {
    "name": "NHK World",
    "url": "https://nhkwlive-xjp.akamaized.net/hls/live/2003458/nhkwlive-xjp-en/index_1M.m3u8"
  },
  {
    "name": "Al Jazeera English",
    "url": "http://aljazeera-eng-hd-live.hls.adaptive.level3.net/aljazeera/english2/index.m3u8"
  }
]
```
* `name` The channel name as you wish for it to appear.
* `url` The URL of the stream. Most times this will include `.m3u8` followed by 0 or more additional arguments

To add channels, all you need to do is add another entry to the list.

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

### Connecting with Plex (as of Plex Version 4.108.0)
1. Navigate to `Settings>Manage>Live TV & DVR`
1. Select the "Set Up Plex DVR" (if you already have a tuner box or dvr connected select "Add Another Device")
1. If Plex automatically finds your device, select it and skip to step 6
1. If Plex does not automatically find your device, select "Don't see your HDHomeRun device? Enter its network address manually"
1. Enter the ip/hostname and port of your device `http://<ip of machine>:5004` and hit "Connect"
1. Plex should have found your device, but before you can proceed to the next step a channel guide must be added. **unless you have only added local channels/streams, do not add your postal code. It will not work**
1. Select "Have an XMLTV guide on your server? Click here to use it."
1. In the "XMLTV GUIDE" box, enter the ip/hostname and port of your device followed by /xmltv: `http://<ip of machine>:5004/xmltv` You may change the guide title if you wish
1. Select "Continue"
1. Validate that channels match the guide
1. Select "Continue"

Setup is now complete

