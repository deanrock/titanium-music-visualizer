#!/bin/bash
set -e 
set -o pipefail

# remove previous zip
rm -f com.deanrock.musicvisualizer-iphone-*.zip
# rm -r build/

# build module
./build.py

zip -d com.deanrock.musicvisualizer-iphone-*.zip modules/iphone/com.deanrock.musicvisualizer/1.0.0/example/\*

# remove existing module
rm -r -f ~/Library/Application\ Support/Titanium/modules/iphone/com.deanrock.musicvisualizer

# copy to titanium folder
unzip -o com.deanrock.musicvisualizer-iphone-*.zip -d ~/Library/Application\ Support/Titanium/

# cd to example folder
cd ../example/music-visualizer-example/

# build example
# titanium clean
titanium build -p ios -C ?
