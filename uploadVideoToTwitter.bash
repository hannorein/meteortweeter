#!/bin/bash
MESSAGE="Meteor video"

SIZE=`stat --format="%s" latest.mp4`
echo "$SIZE"
MEDIAJSON=`/usr/local/bin/twurl -H upload.twitter.com "/1.1/media/upload.json" -d "command=INIT&media_type=video/mp4&total_bytes=$SIZE"`
MEDIAID=`echo "$MEDIAJSON" | sed -rn 's/\{\"media_id\":(.*)\,\"media_id_string.*/\1/p'`
echo "$MEDIAJSON"
echo "$MEDIAID"
INDEX=0
split -b 5m latest.mp4 twitter-video-
for FILE in twitter-video-*; do
    echo "[INFO] Uploading segment $INDEX ($FILE)..."
    /usr/local/bin/twurl "/1.1/media/upload.json" -H upload.twitter.com -d "command=APPEND&segment_index=$INDEX&media_id=$MEDIAID" --file-field "media" --file "$FILE"
    INDEX=$((INDEX + 1))
done
rm twitter-video-*

/usr/local/bin/twurl -H upload.twitter.com "/1.1/media/upload.json" -d "command=FINALIZE&media_id=$MEDIAID"
sleep 1
/usr/local/bin/twurl "/1.1/statuses/update.json" -d "media_ids=$MEDIAID&status=$MESSAGE"
