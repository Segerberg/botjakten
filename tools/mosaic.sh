# Make a mosaic of image files in a folder 96px wide, rows of 50. Assumes imagemagick installed
if [ ! -f $1-mosaic.jpg ]; then
    montage -pointsize 9 -label '%i' -border 0 -geometry 96x -tile 50x $1/*.jpg $1-mosaic.jpg
else
    echo "Exists: $1-mosaic.jpg"
fi
