#!/bin/bash
set -e 
set -o pipefail

rm -rf dist/ example/ documentation/ libs/

# remove previous zip
#rm -f com.deanrock.musicvisualizer-iphone-*.zip
# rm -r build/

# build module
ant

zip -d dist/com.deanrock.musicvisualizer-android-*.zip modules/android/com.deanrock.musicvisualizer/1.0.0/example/\*

# remove existing module
rm -r -f ~/Library/Application\ Support/Titanium/modules/android/com.deanrock.musicvisualizer

# copy to titanium folder
unzip -o dist/com.deanrock.musicvisualizer-android-*.zip -d ~/Library/Application\ Support/Titanium/

# cd to example folder
cd ../example/music-visualizer-example/

# build example
# titanium clean
titanium build -p android -T device
