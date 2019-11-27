import sys
from PIL import Image



if __name__ == '__main__':
    if len(sys.argv) != 4:
        print('usage: ' + sys.argv[0] + ' <input image> <bounding boxes> <output image>')
        exit(1)


    with open(sys.argv[2], 'r') as fp:
        for line in fp:
            # Get bounding box coordinates
            [x1, y1, x2, y2] = [int(a) for a in line.split()]

            # Crop image
            imageObject = Image.open(sys.argv[1])
            cropped = imageObject.crop((x1,y1,x2,y2))
            cropped.show()
            cropped.save(sys.argv[3])
