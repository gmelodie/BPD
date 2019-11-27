

# Brazillian Plate Detector

Detect brazillian license plates from pictures using YOLOv3.This project uses pretrained weights from YOLOv3 and [the brazillian alpr](http://www.inf.ufrgs.br/~smsilva/real-time-brazilian-alpr/)

## Dependencies

Make sure you have `Python 3` installed and then install the `Pillow` module for image cropping:
```
python3 -m pip install Pillow
```

In the last step of our pipeline we need to convert the image to grayscale. For this we use the `convert` utility of [`Imagemagick`](https://imagemagick.org/index.php). Downloading imagemagick might differ slightly depending on the distro you are using, but it will generally be something like
```
sudo pacman -S imagemagick # for arch
sudo apt install imagemagick # for ubuntu
...
```

## Automatic Installation
Just clone this repo
```
git clone https://github.com/gmelodie/bpd
```
And run the initialization script
```
cd bpd
./init-dir.sh
```


## Manual Installation

To run the project you will have to have the `darknet` framework installed as well as the `yolo` network.
For the `darknet`, clone the code with:
```
git clone https://github.com/pjreddie/darknet
```

We use a slightly different `src/image.c` file (in order to be able to save the bounding boxes to a file during execution), so you will need to change the default `src/image.c` for the one found in this project, and then compile the code:
```
cp our/src/image.c darknet/src/image.c
cd darknet
make
```

For this project we have the pre-trained weights for our specific case, which you can download by simply
```
./download-confs.sh
```
This will automatically download all the weights, data and other necessary configuration files into the local directory (make sure you are inside the `darknet` directory cloned earlier. More informations on using yolo with darknet [here](https://pjreddie.com/darknet/yolo/).


## Running full pipeline
Running the code is as simple as typing
```
./detect-plate.sh your/image/file
```
As we didn't run extensive tests, we don't know which types of image files are supported, and which are not. To be safe, make sure you use a `jpg` file as input.


If everything goes well (*fingers crossed*) you should see the cropped images popping up as well as the `predictions.jpg` in the current directory with the predictions of the final cropped image (hopefully, the cropped license plate image).


## Running individual parts

1. Detecting the front of a car
```
./darknet detector test fvlpd.data fvlpd-net.cfg fvlpd-net.weights -thresh .4 <<< <IMAGE_FILE>
```
2. Detecting a plate
```
./darknet detector test fvlpd.data fvlpd-net.cfg fvlpd-net.weights -thresh .2 <<< <FRONTAL_VIEW_FILE>
```
3. Detecting letters from the plate
In order to be able to detect letters from the plate, we need to convert the image to grayscale:

```
convert <COLORED_PLATE_INPUT> -colorspace Gray <GRAYSCALE_PLATE_OUTPUT>
```
And then run the detector
```
./darknet detector test lpscr.data lpscr-net.cfg lpscr-net.weights -thresh .6 <<< <GRAYSCALE_PLATE_FILE>
```
