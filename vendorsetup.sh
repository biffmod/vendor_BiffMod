add_lunch_combo biffmod_dream_sapphire-eng

PATH=$PATH:$PWD/vendor/biffmod/tools ; export PATH

if [ -f $PWD/vendor/biffmod/wireless_tether_2_0_2.apk ]
then
    echo wireless_tether_2_0_2.apk already downloaded
    echo please continue with the build
else
    echo Downloading wireless_tether_2_0_2.apk
    curl -o $PWD/vendor/biffmod/wireless_tether_2_0_2.apk http://android-wifi-tether.googlecode.com/files/wireless_tether_2_0_2.apk
    echo wireless_tether_2_0_2.apk downloaded";" you can now run the build
fi
