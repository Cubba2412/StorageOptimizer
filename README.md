
<h3 align="center">PNG, JPEG/JPG and PDF optimizer and (lossless) compressor</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
<!-- [![GitHub Issues](https://img.shields.io/github/issues/kylelobo/The-Documentation-Compendium.svg)](https://github.com/Cubba2412/DarkWeb-Scraper/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/kylelobo/The-Documentation-Compendium.svg)](https://github.com/Cubba2412/DarkWeb-Scraper/pulls) -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> 
  Bash script used for optimizing and losslessly compressing PNG, JPEG/JPG and PDF files.
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Built Using](#built_using)
<!-- - [TODO](../TODO.md)
- [Contributing](../CONTRIBUTING.md) -->
- [Authors](#authors)
<!-- - [Acknowledgments](#acknowledgement) -->

## 🧐 About <a name = "about"></a>

The script contained in this repository allows a user on a unix system to optimize and losslessly compress PNG, JPEG/JPG and PDF documents. 

## 🏁 Getting Started <a name = "getting_started"></a>

The script runs out of the box. Simply download the script and run. If any of the tools in [Prerequisites](#Prerequisites) are not install on the system, the script will prompt for sudo access to install these.

### Prerequisites

The script utilizes 3 different tools for optimizing PNG, JPG/JPEG and PDF respectively.

1. optipng

2. jpegoptim

3. pdfsizeopt 

### Installing

You can either let the script install these for you or you can execute the following steps:

1. Install optipng (``` sudo apt-get install optipng ```)

1. Install jpegoptim (``` sudo apt-get install jpegoptim ```)

3. Install pdfsizeopt (https://github.com/pts/pdfsizeopt)
 

## 🎈 Usage <a name="usage"></a>

Open a command prompt in whatever folder you wish to optimize files and run the script ``` ./StorageOptimizer.sh ```. The script will recursively run through all sub-directories in the directory it is run to optimize files as well as the folder it is run in.

## ⛏️ Built Using <a name = "built_using"></a>

- [optipng](http://optipng.sourceforge.net/) - PNG optimizer
- [jpegoptim](https://github.com/tjko/jpegoptim) - JPEG/JPG optimizer
- [pdfsizeopt](https://github.com/pts/pdfsizeopt) - PDF optimizer

## ✍️ Authors <a name = "authors"></a>

- [@Cubba2412](https://github.com/Cubba2412)
