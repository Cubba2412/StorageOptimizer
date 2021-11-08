#!/bin/bash
# Script to optimize and compress JPEG, PNG images and PDF documents

# This script requires the optipng, the jpegoptim package and the pdfsizeopt package
# This can be installed with sudo apt-get install optipng jpegoptim, and from: https://github.com/pts/pdfsizeopt)

# The optimize PNG part takes a VERY LONG TIME as it tries to 
# find the absolute optimal compression without loosing quality


# Note pdfsizeopt requires to install image optimizers specified in the link above
function usage() {
    cat <<USAGE

    Usage: $0 [--verbose] [--very-verbose]

    Options:
        -v, --verbose:          Print info regarding optimization and compression of files (PNG and JPEG/JPG)
        -vv, --ver-verbose:     Print all info regarding optimization and compression of files (PNG, JPEG/JPG and PDF)  
USAGE
    exit 1
}

for arg in "$@"; do
    case $arg in
    --verbose | -v)
        VERBOSE=true
        shift # Remove --verbose from `$@`
        ;;
    --very-verbose | -vv)
        VERY_VERBOSE=true
        ;;
    --help | -h)
        usage # run usage function on help
        ;;
    *)
    esac
done
CURRENT_DIR=$(pwd)
# AddMultivalentToBin () {
#     echo "Adding Multivalent to /usr/local/bin...\n"
#     cp ./Multivalent20060102.jar /usr/local/bin
#     chmod +x /usr/local/bin
# }

AddAlias () {
    aliasName=$1
    pathToProgram=$2
# Function to add the Multivalent alias to bashrc and zshrc
    if test -f ~./bashrc; then
        if !(cat ~/.bashrc | grep alias | grep $aliasName -q); then
            printf "Adding alias $aliasName... to ~/.bashrc...\n"
            echo "alias $aliasName=$pathToProgram" >> ~/.bashrc # Add alias
        else
            printf "Alias $aliasName already present in ~/.bashrc\n"
        fi
        if !(cat ~/.bashrc | grep 'export' | cut -d ""'"'"" -f 2 | grep $pathToProgram -q); then
                echo 'export PATH="/usr/local/bin/pdfsizeopt/:/usr/local/bin/pdfsizeopt/pdfsizeopt_libexec:/usr/local/bin/:$PATH"' >> ~/.bashrc # Add to PATH
        else
            printf "Path to alias $aliasName already present in export PATH in~/.bashrc\n "
        fi
    fi
    if  test -f ~/.zshrc; then
        if !(cat ~/.zshrc | grep alias | grep $aliasName -q); then
            printf "Adding alias $aliasName... to ~/.zshrc...\n"
            echo "alias $aliasName=$pathToProgram" >> ~/.zshrc
        else
            printf "Alias $aliasName already present in ~/.bashrc\n"
        fi
        if !(cat ~/.zshrc | grep 'export' | cut -d ""'"'"" -f 2 | grep $pathToProgram -q); then
                echo 'export PATH="/usr/local/bin/pdfsizeopt/:/usr/local/bin/pdfsizeopt/pdfsizeopt_libexec:/usr/local/bin/:$PATH"' >> ~/.zshrc # Add to PATH
        else
            printf "Path to alias $aliasName already present in export PATH in~/.zshrc\n "
        fi
    fi
}

AddPdfsizeoptToBin () {
    echo "Adding pdfsizeopt to /usr/local/bin...\n"
    # Pdfsizeopt
    mkdir ~/pdfsizeopt
    cd ~/pdfsizeopt
    wget -O pdfsizeopt_libexec_linux.tar.gz https://github.com/pts/pdfsizeopt/releases/download/2017-01-24/pdfsizeopt_libexec_linux-v3.tar.gz
    tar xzvf pdfsizeopt_libexec_linux.tar.gz
    rm -f    pdfsizeopt_libexec_linux.tar.gz
    wget -O pdfsizeopt.single https://raw.githubusercontent.com/pts/pdfsizeopt/master/pdfsizeopt.single
    chmod +x pdfsizeopt.single
    echo "Adding Image optimizers for pdfsizeopt to /usr/local/bin...\n"
    # Image optimizers
    wget -O pdfsizeopt_libexec_extraimgopt_linux-v3.tar.gz https://github.com/pts/pdfsizeopt/releases/download/2017-01-24/pdfsizeopt_libexec_extraimgopt_linux-v3.tar.gz
    tar xzvf pdfsizeopt_libexec_extraimgopt_linux-v3.tar.gz
    rm -f    pdfsizeopt_libexec_extraimgopt_linux-v3.tar.gz
    ln -s pdfsizeopt.single pdfsizeopt
    cd $CURRENT_DIR
}

CheckPackage () {
    package=$1
    echo "Checking if $package is already installed..."
    if [ $(dpkg-query -W -f='${Status}' $package 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        if [ "$EUID" -ne 0 ]
            then echo "$package is not installed on this system. Run this script as root to install $package."
            exit
        fi
        apt-get install $package -y;
    else
        echo "Package $package already installed"
    fi  
}

# STEP 1: CHECK IF MULTIVALENT IS AVAILABLE. OTHERWISE DOWNLOAD IT, MOVE IT TO BIN AND CREATE ALIAS FOR IT
# echo "Checking if Multivalent is already installed..."
# if test -f /usr/local/bin/Multivalent20060102.jar; then
#     AddAlias 'multivalent' "'"'"/usr/local/bin/Multivalent20060102.jar"'"'"
# else
#     if !(test -f ./Multivalent20060102.jar); then
#         wget https://web.archive.org/web/20150919020215/http://www.vrspace.org/sdk/java/multivalent/Multivalent20060102.jar
#         AddMultivalentToBin
#         AddAlias 'multivalent' "'"'"/usr/local/bin/Multivalent20060102.jar"'"'"
#     else
#         AddMultivalentToBin
#         AddAlias 'multivalent' "'"'"/usr/local/bin/Multivalent20060102.jar"'"'"
#     fi
# fi
# The Multivalent Jar has to be in the directory it is executed. Hence it must be added to all folders with pdf files.
# PutMultivalentInEachDirectoryWithPDF () {
#     DIRS=$(find . -type f -name '*.pdf' -printf '%h\0' | sort -zu | sed -z 's/$/\n/' | tr -d '\0')
#     for d in $DIRS; do
#         if [[ "$d" != "." ]]; then
#             cp ./Multivalent20060102.jar $d
#         fi
#     done;
# }

# if !(test -f ./Multivalent20060102.jar); then
#     wget https://web.archive.org/web/20150919020215/http://www.vrspace.org/sdk/java/multivalent/Multivalent20060102.jar
#     PutMultivalentInEachDirectoryWithPDF
# else
#     PutMultivalentInEachDirectoryWithPDF
# fi


# STEP 2: CHECK IF pdfsizeopt IS AVAILABLE. OTHERWISE DOWNLOAD IT, MOVE IT TO BIN, ADD TO PATH AND CREATE ALIAS
echo "Checking if pdfsizeopt is already installed..."
if test -f /usr/local/bin/pdfsizeopt/pdfsizeopt.single; then
    AddAlias 'pdfsizeopt' "'"'"/usr/local/bin/pdfsizeopt/pdfsizeopt"'"'"
else
    if [ "$EUID" -ne 0 ]
        then echo "pdfsizeopt is not installed on this system. Run this script as root to install pdfsizeopt"
        exit
    fi
    if test -f /usr/local/bin/pdfsizeopt/pdfsizeopt.single; then
        AddPdfsizeoptToBin
        AddAlias 'pdfsizeopt' "'"'"/usr/local/bin/pdfsizeopt/pdfsizeopt"'"'"
    else
        AddPdfsizeoptToBin
        AddAlias 'pdfsizeopt' "'"'"/usr/local/bin/pdfsizeopt/pdfsizeopt"'"'"
    fi
fi

# STEP 3: CHECK IF optipng AND jpegoptim IS AVAILABLE. OTHERWISE INSTALL THEM
CheckPackage "optipng" 
CheckPackage "jpegoptim"

# STEP 4: GET FILE SIZE OF ALL PNG, JPEG AND PDF FILES ACCUMULATED
TotalPDFSizeInitial=$(find ./ -type f -name '*.pdf' -exec du -cb {} + | grep total | awk '{print $1}')
TotalPNGSizeInitial=$(find ./ -type f -name '*.png' -exec du -cb {} + | grep total | awk '{print $1}')
JPG=$(find ./ -type f -name '*.jpg' -exec du -cb {} + | grep total | awk '{print $1}')
# Test if the variable is empty
if test -z $JPG;then
    JPG=0
fi
JPEG=$(find ./ -type f -name '*.jpeg' -exec du -cb {} + | grep total | awk '{print $1}')
if test -z $JPEG;then
    JPEG=0
fi

TotalJPEGSizeInitial=`expr $JPG + $JPEG`
printf "\nFound $(echo $TotalPDFSizeInitial | bc -l | xargs -0 numfmt --to iec --format "%8.2f" --suffix=B) of PDF files \n"
printf "Found $(echo $TotalPNGSizeInitial | bc -l | xargs -0 numfmt --to iec --format "%8.2f" --suffix=B) of PNG files \n"
printf "Found $(echo $TotalJPEGSizeInitial | bc -l | xargs -0 numfmt --to iec --format "%8.2f" --suffix=B) of JPEG/JPG files \n"
    
# STEP 5: LOOP THROUGH DIRECTORIES AND OPTIMIZE PNG, JPEG AND PDF
# For pfd files firstly run through pdfsizeopt and nextly through old version of Multivalent java class (Downloaded from: https://web.archive.org/web/20150919020215/http://www.vrspace.org/sdk/java/multivalent/Multivalent20060102.jar)
printf "\n\n /////////////////////STARTING OPTIMIZATION///////////////////// \n\n"
cd "$CURRENT_DIR"
find ./ -type d -print0 | sed 's/$/./' | while IFS= read -r -d '' dir; do
        (cd "$dir" && \
        count=`find ./ -maxdepth 1 -name "*.png" | wc -l` && \
        if [ "$count" != 0 ]; then
            (printf "\n\nOptimizing and compressing PNG's in $dir...\n\n") && \
            if [[ $VERBOSE == true ]] || [[ $VERY_VERBOSE == true ]]; then
                (find . -iname '*.png' -print0 | xargs --no-run-if-empty -0 optipng -o7 -preserve)
            else
                (find . -iname '*.png' -print0 | xargs --no-run-if-empty -0 optipng -o7 -preserve > /dev/null 2>&1)
            fi;
            (printf "\n\n\n\n ####################\n\n   PNG images in $dir scanned and optimized \n\n ####################\n\n\n\n");
        fi;
        count=`find ./ -maxdepth 1 -name "*.jpg" | wc -l` && \
        if [ "$count" != 0 ]; then
            (printf "Optimizing and compressing JPEG's in $dir...\n\n") && \
            if [[ $VERBOSE == true ]] || [[ $VERY_VERBOSE == true ]]; then
                (find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -exec jpegoptim -f --preserve --strip-none -t {} \;);
            else
                (find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -exec jpegoptim -f --preserve --strip-none -t {} \; > /dev/null 2>&1);
            fi;
        fi;
        count=`find ./ -maxdepth 1 -name "*.pdf" | wc -l` && \
        if [ "$count" != 0 ]; then
            (printf "\n\nOptimizing and compressing PDF's in $dir...\n\n") && \
            for pdfFile in ./*.pdf; do  
                # If the directory is empty, the pdfFile variable will contain "./*.pdf" which doesn't exist. The if statement is there to counter this.
                if [ "$pdfFile" != './*.pdf' ]; then 
                (printf "\n Optimizing $pdfFile with pdfsizeopt...\n" && \
                    if [[ $VERY_VERBOSE == true ]]; then
                        pdfsizeopt "$pdfFile" "$pdfFile"
                    else
                        pdfsizeopt "$pdfFile" "$pdfFile" > /dev/null 2>&1
                    fi;
                )
                fi;
            done;
            (printf "\n\n\n\n ####################\n\n    PDF's in $dir scanned and optimmized. \n\n ####################\n\n\n\n ")
        fi;
        )
    done;
cd "$CURRENT_DIR"
# Remove Multivalent from folder
# for d in ./*/; do
#     (cd "$d" && (find . -name "Multivalent20060102.jar" -type f -delete))
# done

# PNG
TotalPNGSizeFinal=$(find ./ -type f -name '*.png' -exec du -cb {} + | grep total | awk '{print $1}')
PNGReductionPercentage=`echo "(1-($TotalPNGSizeFinal/$TotalPNGSizeInitial))*100" | bc -l | xargs printf "%.2f"`

#JPEG
JPG=$(find ./ -type f -name '*.jpg' -exec du -cb {} + | grep total | awk '{print $1}')
JPEG=$(find ./ -type f -name '*.jpeg' -exec du -cb {} + | grep total | awk '{print $1}')
# Test if the variable is empty
if test -z $JPG;then
    JPG=0
fi
if test -z $JPEG;then
    JPEG=0
fi

TotalJPEGSizeFinal=`expr $JPG + $JPEG`
JPEGReductionPercentage=`echo "(1-($TotalJPEGSizeFinal/$TotalJPEGSizeInitial))*100" | bc -l | xargs printf "%.2f"`

# PDF
TotalPDFSizeFinal=$(find ./ -type f -name '*.pdf' -exec du -cb {} + | grep total | awk '{print $1}')
PDFReductionPercentage=`echo "(1-($TotalPDFSizeFinal/$TotalPDFSizeInitial))*100" | bc -l | xargs printf "%.2f"`

printf "\n\n\n\n ####################\n\n    Finished optimizing PDF,PNG, JPG and JPEG in $CURRENT_DIR and its subdirectories  \n\n ####################\n\n\n\n"
printf "Total size reduction for PNG: $(echo $TotalPNGSizeInitial | bc -l | xargs -0 numfmt --to iec --format "%8.2f" --suffix=B) to $(echo $TotalPNGSizeFinal |  bc -l | xargs -0 numfmt --to iec --format "%8.2f" --suffix=B) ($PNGReductionPercentage%% reduction)\n"
printf "Total size reduction for JPEG: $(echo $TotalJPEGSizeInitial |  bc -l | xargs -0 numfmt --to iec --format "%8.2f" --suffix=B) to $(echo $TotalJPEGSizeFinal |  bc -l | xargs -0 numfmt --to iec --format "%8.2f" --suffix=B) ($JPEGReductionPercentage%% reduction) \n"
printf "Total size reduction for PDF: $(echo $TotalPDFSizeInitial |  bc -l | xargs -0 numfmt --to iec --format "%8.2f" --suffix=B) to $(echo $TotalPDFSizeFinal |  bc -l | xargs -0 numfmt --to iec --format "%8.2f" --suffix=B) ($PDFReductionPercentage%% reduction) \n"

