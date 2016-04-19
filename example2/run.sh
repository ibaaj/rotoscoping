#!/bin/zsh
# github.com/ibaaj/rotoscoping MIT Licensed
ffmpeg -i example2.mov -t 15 part1.mov;
ffmpeg -i example2.mov -ss 00:00:15 part2.mov;

mkdir -p {tmpframes1,tmpframes2,frames};

ffmpeg -i part1.mov -r 25 -qscale:v 2 tmpframes1/%05d.jpg ;
ffmpeg -i part2.mov -r 25 -qscale:v 2 tmpframes2/%05d.jpg ;

framesNb1=$(ls ./tmpframes1/*.jpg |wc -l|tr -d ' ');
framesNb2=$(ls ./tmpframes2/*.jpg |wc -l|tr -d ' ');

min=$( (( $framesNb1 <= $framesNb2 )) && echo "$framesNb1" || echo "$framesNb2" )

for i in {1..${min}}
do
    nb=$(printf %05d ${i})
    composite tmpframes1/${nb}.jpg tmpframes2/${nb}.jpg -gravity center -compose Darken frames/${nb}.jpg;
done

convert -layers Optimize frames/*.jpg out.gif;
cat ./frames/*.jpg | ffmpeg -f image2pipe -r 25 -vcodec mjpeg -i - -vcodec libx264 out.mp4;
