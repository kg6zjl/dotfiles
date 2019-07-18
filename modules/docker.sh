IMAGE="$HOME/tmp/Docker.dmg"

mkdir -p $HOME/tmp && cd $HOME/tmp/
echo "Downloading docker image"
curl -s -L -o $IMAGE https://download.docker.com/mac/stable/Docker.dmg

#mount the image
echo "mounting the downloaded dmg"
hdiutil mount $IMAGE
  
#install the package
echo "copying app to Applications"
cp -r "/Volumes/Docker/Docker.app" /Applications/

#cleanup
echo "cleaning up"
hdiutil unmount -force "/Volumes/Docker"
rm -f $IMAGE
