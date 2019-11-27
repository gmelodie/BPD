
if [ $# != 1 ]; then
	echo "usage: $0 <input image>"
    exit 1
fi

# Detect frontal view of the cars
./darknet detector test fvlpd.data fvlpd-net.cfg fvlpd-net.weights -thresh .4 <<< "$1"

# Crop frontal views
python3 crop.py $1 metadata/boundingboxes.txt metadata/frontal-view.jpg

# Detect plates
./darknet detector test fvlpd.data fvlpd-net.cfg fvlpd-net.weights -thresh .2 <<< "metadata/frontal-view.jpg"

# Crop plates
python3 crop.py metadata/frontal-view.jpg metadata/boundingboxes.txt metadata/plate.jpg

# Convert plates to grayscale
convert metadata/plate.jpg -colorspace Gray metadata/gray-plate.jpg

# Detect each letter
./darknet detector test lpscr.data lpscr-net.cfg lpscr-net.weights -thresh .6 <<< "metadata/gray-plate.jpg"


