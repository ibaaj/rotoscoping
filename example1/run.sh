#!/bin/zsh
# github.com/ibaaj/rotoscoping MIT Licensed 
mkdir -p ./frames/;
ffmpeg -i example1.mov -r 25 -qscale:v 2 frames/%05d.jpg ;
framesNumber=$(ls ./frames/*.jpg |wc -l|tr -d ' ');

for i in {11..${framesNumber}}
  do
     fNbTarget=$(printf %05d $((${i}-10)));
     fCurrent=$(printf %05d ${i});
     composite frames/${fNbTarget}.jpg frames/${fCurrent}.jpg -gravity center -compose Darken frames/${fCurrent}.jpg;
 done

 convert -layers Optimize frames/*.jpg out.gif;
 cat ./frames/*.jpg | ffmpeg -f image2pipe -r 25 -vcodec mjpeg -i - -vcodec libx264 out.mp4;
