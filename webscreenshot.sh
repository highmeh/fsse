#!/bin/bash
while getopts f: flag
do
    case "${flag}" in
        f) filename=${OPTARG};;
    esac
done

while read i; 
do
        echo Screenshotting: $i
        cutycapt --url=https://$i --out=$i.jpg
done < $filename

