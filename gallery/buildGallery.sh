#!/bin/bash

# change to the directory of the shellscript
BASEDIR=$(dirname $0)

# delete previously generated galleries
rm -Rf target

mkdir target
mkdir target/highres
mkdir target/images
mkdir target/thumb
cp resources/* target


CPCOMMAND="$1"
CPCOMMAND=$(echo "$CPCOMMAND" | sed 's/ / /')
cp "$CPCOMMAND"/*.jpg target/highres

cp -R target/highres/* target/images
cp -R target/highres/* target/thumb

cd target
zip highres.zip highres/*
rm -Rf highres

mogrify -verbose -resize "800x800>" images/*.jpg
mogrify -verbose -resize "100x100>" thumb/*.jpg
cd ..

sed -i "s/###TITLE###/$2/" target/index.html

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<simpleviewerGallery maxImageWidth=\"800\" maxImageHeight=\"800\" textColor=\"0xFFFFFF\" frameColor=\"0xFFFFFF\" frameWidth=\"20\" stagePadding=\"40\" thumbnailColumns=\"3\" thumbnailRows=\"4\" navPosition=\"left\" title=\"\" enableRightClickOpen=\"true\" backgroundImagePath=\"\" imagePath=\"images/\" thumbPath=\"thumb/\">" > target/gallery.xml

cd target/images
for f in *.jpg; do 
	echo "<image>
<filename>$f</filename>
<caption></caption>
</image>" >> ../gallery.xml
done
cd ../..


echo "</simpleviewerGallery>" >> target/gallery.xml
