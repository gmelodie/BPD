# Get original directory
ROOTDIR="$(pwd)"

# Download darknet
git clone https://github.com/pjreddie/darknet
cd darknet

# Download configuration files
$ROOTDIR/download-confs.sh

# Copy additional files
cp $ROOTDIR/crop.py .
cp $ROOTDIR/detect-plate.sh .
cp $ROOTDIR/image.c ./src/image.c
cp -r $ROOTDIR/images .

mkdir metadata

echo "Recompiling with new image.c..."
make
