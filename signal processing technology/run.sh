#!/bin/sh

rm result/*

# imagemagickで何か画像処理をして，/imgprocにかきこみ，テンプレートマッチング


for image in $1/*.ppm; do
    bname=`basename ${image}`
    name="imgproc/"$bname

    convert "${image}" $name # 何もしない画像処理
    rotation=0
    echo $bname:

#level1,3,4
    for template in $2/*.ppm; do		
	    ./matching $name "${template}" 0 1.0 p &
    done

#level5
   for template in $2/*.ppm; do
	tname="imgproc/"`basename ${template}`
	convert -resize 50% "${template}" "$tname"
	    ./matching $name $tname rotation 1.0 pg &
    done

    for template in $2/*.ppm; do
	tname="imgproc/"`basename ${template}`
	convert -resize 200% "${template}" "$tname"
	    ./matching $name $tname rotation 0.1 pg &
    done

#level6
    for template in $2/*.ppm; do
 	tname="imgproc/"`basename ${template}`	
	convert -rotate 90 "${template}" "${tname}"
	    ./matching $name $tname 90 0.5 p &
    done

    for template in $2/*.ppm; do
 	tname="imgproc/"`basename ${template}`	
	convert -rotate 180 "${template}" "${tname}"
	    ./matching $name $tname 180 0.5 p  &
    done

    for template in $2/*.ppm; do
 	tname="imgproc/"`basename ${template}`	
	convert -rotate 270 "${template}" "${tname}"
	    ./matching $name $tname 270 0.5 p  &
    done

    echo ""
done

for image in $1/*.ppm; do
    bname=`basename ${image}`
    name="imgproc/"$bname
    rotation=0
    echo $bname:
#level2
    convert -median 1 "${image}" "${name}"
    for template in $2/*.ppm; do	
	    ./matching $name  "${template}" rotation 1.0 p &
    done
    echo ""
done
