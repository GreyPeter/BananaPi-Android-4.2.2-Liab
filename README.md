# BananaPi-Android-4.2.2-Liab
# BananaPi Android 4.2.2 sources (liab version)
Have forked this project to try and get it to compile using MacOS (GreyPeter)
=======

To get started:

apt-get install git #Install git if required

#Get the Source code

git clone https://github.com/ChrisP-Android/BananaPi-Android-4.2.2-Liab android 

#Get svox PicoTTs from google to avoid DMCA notification on this repo!  
  
cd android/android/external

git clone https://android.googlesource.com/platform/external/svox

folder android/scripts : Various scripts to build and configure (to be detailed later)

folder android/user : Various scripts and file to personnalize build without changing the code itself (to be detailed later)

# Missing elf.h
Here is what I've done to this issue:

sudo port install libelf
sudo mkdir /us	r/local/include
sudo ln -s /opt/local/include/libelf /usr/local/include/libelf
Download elf.h https://issuetracker.google.com/action/issues/36907893/attachments/10503034?download=true
copy elf.h to /usr/local/include 
sudo cp ~/Downloads/elf.h /usr/local/include
sudo port install gsed
create /usr/local/include/malloc.h to simply contain #include <sys/malloc.h> 
