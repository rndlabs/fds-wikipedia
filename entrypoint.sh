#!/bin/bash
echo "Swarmifying Wikipedia"
echo "---------------------"
echo ""
echo "Source ZIM URL: $SOURCE_URL"
echo "API URL: $BEE_API_URL"
echo "Postage batch: $BEE_HERDER_BEE_POSTAGE_BATCH"
echo "Upload rate: $BEE_HERDER_UPLOAD_RATE"
echo ""

export BEE_HERDER_DB="/data/db"

# Make the directory for the download
mkdir -p /data/download

# Download the `zim` file
curl -o /data/download/wikipedia.zim $SOURCE_URL

# Now process with the extractor
/usr/bin/wiki_extractor -i /data/download/wikipedia.zim -o /data/output

# Upload everything that we have
/usr/bin/bee_herder upload --db $BEE_HERDER_DB $BEE_API_URL $BEE_HERDER_BEE_POSTAGE_BATCH $BEE_HERDER_UPLOAD_RATE

# Generate the manifest index
MANIFEST_QUOTE=$(/usr/bin/bee_herder manifest --db $BEE_HERDER_DB $BEE_API_URL $BEE_HERDER_BEE_POSTAGE_BATCH 1500 8 50 index.html index.html "media/" "wiki/")
MANIFEST="${MANIFEST_QUOTE:1:-1}"

echo "Wikipedia content manifest root: $MANIFEST"

# Download the swarm wikipedia site, build it, and merge it
git clone https://github.com/rndlabs/swarm-wikipedia.git /tmp/swarm-wikipedia
cd /tmp/swarm-wikipedia
npm i
npm run build

# Set a temporary database
export BEE_HERDER_DB="/data/db_website"

# Import the website
/usr/bin/bee_herder import --db $BEE_HERDER_DB /tmp/swarm-wikipedia/dist

# Upload the chunks
/usr/bin/bee_herder upload --db $BEE_HERDER_DB $BEE_API_URL $BEE_HERDER_BEE_POSTAGE_BATCH $BEE_HERDER_UPLOAD_RATE

# Push and merge the manifest
MANIFEST_QUOTE=$(/usr/bin/bee_herder manifest --db $BEE_HERDER_DB --merge-manifest $MANIFEST $BEE_API_URL $BEE_HERDER_BEE_POSTAGE_BATCH 1500 8 50 index.html index.html)
MANIFEST="${MANIFEST_QUOTE:1:-1}"

echo "The wikipedia is now available at $BEE_API_URL/bzz/$MANIFEST/"