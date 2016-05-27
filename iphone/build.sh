#!/bin/bash

# remove previous zip
rm com.deanrock.musicvisualizer-iphone-*.zip

# build module
./build.py

# remove existing module
rm -r ~/Library/Application\ Support/Titanium/modules/iphone/com.deanrock.musicvisualizer

# copy to titanium folder
unzip -o com.deanrock.musicvisualizer-iphone-*.zip -d ~/Library/Application\ Support/Titanium/

# cd to example folder
cd ../example/music-visualizer-example/

# build example
#titanium clean
titanium build -p ios -C ?
