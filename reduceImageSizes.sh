#!/bin/bash
# Script to optimize and compress JPEG, PNG images and PDF documents

# This script requires the optipng and the jpegoptim package
# This can be installed with sudo apt-get install optipng jpegoptim

# The optimize PNG part takes a VERY LONG TIME as it tries to 
# find the absolute optimal compression without loosing quality
if cat ~/.bashrc | grep alias | grep Multivalent -q; then
    #do nothing
else
    echo "alias multivalent_compress = /usr/local/bin/Multivalent20060102.jar tool.pdf.Compress" >> ~/.bashrc
    if  test -f ~/.zshrc; then
        echo "alias multivalent_compress = /usr/local/bin/Multivalent20060102.jar tool.pdf.Compress" >> ~/.zshrc
    fi
fi

for d in ./*/; do
    (cd "$d" && (printf "Optimizing and compressing PNG's in $d...\n\n") \
    && (find . -iname '*.png' -print0 | xargs -0 optipng -o7 -preserve) \
    && (printf "\n\n\n\n ####################\n\n   PNG images in $d scanned and optimized \n\n ####################\n\n\n\n ") \
    # source: https://linuxnightly.com/losslessly-compress-jpg-images-via-linux-command-line/
    && (printf "Optimizing and compressing JPEG's in $d...\n\n")\
    && (find . -type f \( -iname "*.jpg" \) -print0 | xargs -0 -P 4 jpegoptim --preserve --strip-none -t)\
#                                                              -P 4 = run 4 CPU cores
    && (printf "Optimizing and compressing PDF's in $d...\n\n")\
    # Firstly run through pdfsizeopt (downloaded from:https://github.com/pts/pdfsizeopt)
    # Note requires to install image optimizers specified in the link
    && for name in ./*.pdf; do
        pdfsizeopt "$name" "$name"
    # Nextly run through old version of Multivalent java class (Downloaded from: https://web.archive.org/web/20150919020215/http://www.vrspace.org/sdk/java/multivalent/Multivalent20060102.jar)
    # This jar executable must be either in the directory it is used or in the java class path
    # Alternatively create an alias (i.e alias multivalent_compress = /usr/local/bin/Multivalent20060102.jar tool.pdf.Compress)
    java -cp Multivalent20060102.jar tool.pdf.Compress "$name"
    # As the output of multivalent will always be the name of the file with an '-o' appended to it, remove the old file
    # and keep the new one while removing the '-o' in the filename
    rm "$name"
    mv "${name%.*}-o.pdf" "$name"

    &&(printf "\n\n\n\n ####################\n\n    PDF's in $d scanned and optimmized. \n\n ####################\n\n\n\n ") \

done;

