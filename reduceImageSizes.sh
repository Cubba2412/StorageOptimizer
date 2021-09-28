#!/bin/bash
# Script to optimize and compress JPEG, PNG images and PDF documents

# This script requires the optipng, the jpegoptim package and the pdfsizeopt package
# This can be installed with sudo apt-get install optipng jpegoptim, and from: https://github.com/pts/pdfsizeopt)
# It also uses Multivalent, however this will be added if it doesn't already exist.

# The optimize PNG part takes a VERY LONG TIME as it tries to 
# find the absolute optimal compression without loosing quality
AddMultivalentAlias () {
# Function to add the Multivalent alias to bashrc and zshrc
    if test -f ~./bashrc; then
        if ! cat ~/.bashrc | grep alias | grep Multivalent -q; then
            echo "alias multivalent_compress = /usr/local/bin/Multivalent20060102.jar tool.pdf.Compress" >> ~/.bashrc
        fi
    fi
    if  test -f ~/.zshrc; then
        if ! cat ~/.zshrc | grep alias | grep Multivalent -q; then
            echo "alias multivalent_compress = /usr/local/bin/Multivalent20060102.jar tool.pdf.Compress" >> ~/.zshrc
        fi
    fi
}

AddMultivalentToBin () {
    cp ./Multivalent20060102.jar /usr/local/bin
    chmod +x /usr/local/bin
}

# STEP 1: CHECK IF MULTIVALENT IS AVAILABLE. OTHERWISE DOWNLOAD IT, MOVE IT TO BIN AND CREATE ALIAS FOR IT
if test -f /usr/local/bin/Multivalent20060102.jar; then
    AddMultivalentAlias
else
    if !test -f ./Multivalent20060102.jar; then
        wget https://web.archive.org/web/20150919020215/http://www.vrspace.org/sdk/java/multivalent/Multivalent20060102.jar
        AddMultivalentToBin
        AddMultivalentAlias
    else
        AddMultivalentToBin
        AddMultivalentAlias
    fi
fi
# STEP 2: CHECK IF pdfsizeopt IS AVAILABLE. OTHERWISE DOWNLOAD IT, MOVE IT TO BIN, ADD TO PATH AND CREATE ALIAS


# STEP 3: CHECK IF optipng AND jpegoptim IS AVAILABLE. OTHERWISE INSTALL THEM

# STEP 4: GET FILE SIZE OF ALL PNG, JPEG AND PDF FILES ACCUMULATED

# STEP 5: LOOP THROUGH DIRECTORIES AND OPTIMIZE PNG, JPEG AND PDF
for d in ./*/; do
    (cd "$d" && (printf "Optimizing and compressing PNG's in $d...\n\n") \
    
    #=============PNG OPTIMIZATION=============#
    && (find . -iname '*.png' -print0 | xargs -0 optipng -o7 -preserve) \
    && (printf "\n\n\n\n ####################\n\n   PNG images in $d scanned and optimized \n\n ####################\n\n\n\n ") \
    
    #=============JPEG OPTIMIZATION=============#
    && (printf "Optimizing and compressing JPEG's in $d...\n\n") \
    # source: https://linuxnightly.com/losslessly-compress-jpg-images-via-linux-command-line/
    && (find . -type f \( -iname "*.jpg" \) -print0 | xargs -0 -P 4 jpegoptim --preserve --strip-none -t) \
#                                                              -P 4 = run 4 CPU cores
    && (printf "Optimizing and compressing PDF's in $d...\n\n")\
    #=============PDF OPTIMIZATION=============#

    # Firstly run through pdfsizeopt
    # Note requires to install image optimizers specified in the link
    && for name in ./*.pdf; do
        (pdfsizeopt "$name" "$name" \
    
    # Nextly run through old version of Multivalent java class (Downloaded from: https://web.archive.org/web/20150919020215/http://www.vrspace.org/sdk/java/multivalent/Multivalent20060102.jar)
    # This jar executable must be either in the directory it is used or in the java class path
    
        && java -cp multivalent_compress "$name" \
    # As the output of multivalent will always be the name of the file with an '-o' appended to it, remove the old file
    # and keep the new one while removing the '-o' in the filename
        && rm "$name" \
        && mv "${name%.*}-o.pdf" "$name")
    done; \
    && (printf "\n\n\n\n ####################\n\n    PDF's in $d scanned and optimmized. \n\n ####################\n\n\n\n "))

done;

