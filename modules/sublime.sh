IMAGE="$HOME/tmp/sublime.dmg"

mkdir -p $HOME/tmp/Sublime && cd $HOME/tmp/
curl -s -L -o $IMAGE https://download.sublimetext.com/Sublime%20Text%20Build%203176.dmg

#mount the image
echo "mounting the downloaded dmg"
hdiutil mount $IMAGE
  
#install the package
echo "copying sublime to Applications"
cp -r "/Volumes/Sublime Text/Sublime Text.app" /Applications/

#cleanup
echo "cleaning up"
hdiutil unmount -force "/Volumes/Sublime Text/"
rm -f $IMAGE