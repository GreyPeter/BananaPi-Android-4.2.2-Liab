# BananaPi-Android-4.2.2-Liab
# BananaPi Android 4.2.2 sources (liab version)
Have forked this project to try and get it to compile using MacOS (GreyPeter)
=======

To get started:

#Install git if required
apt-get install git 

#Get the Source code

git clone --recurse-submodules https://github.com/GreyPeter/BananaPi-Android-4.2.2-Peter.git android 

#Get svox PicoTTs from google to avoid DMCA notification on this repo!  
  
cd android/android/external

git clone https://android.googlesource.com/platform/external/svox

folder android/scripts : Various scripts to build and configure (to be detailed later)

folder android/user : Various scripts and file to personnalize build without changing the code itself (to be detailed later)
