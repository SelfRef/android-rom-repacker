#!/bin/sh

if [ -z $1 ]; then
	echo 'Missing rom file parameter'
	exit 2
fi
romFilePath=$1
romFile=`basename -- "$romFilePath"`
romFileName="${romFile%.*}"
romFileExt="${romFile##*.}"
if [ ! -f "$romFilePath" ]; then
	echo 'Specified rom file does not exist'
	exit 3
fi
if [ -e rom ]; then rm -rf rom; fi
mkdir rom

echo "Unpacking files from '$romFile'"
aunpack -X rom $romFile file_contexts.bin system.transfer.list system.new.dat

echo 'Creating raw image'
bin/sdat2img.py rom/system.transfer.list rom/system.new.dat rom/system.img > /dev/null

echo 'Converting file_contexts.bin'
bin/sefcontext_decompile rom/file_contexts.bin

echo 'Mounting system file'
mkdir output
sudo mount rom/system.img output/

if [ $2 = 'mount' ]; then exit; fi

echo 'Applying scripts'
cd output
for script in ../sh/*.sh; do sudo sh $script; done
cd ..

echo 'Creating new raw image'
imgSize=`du -b rom/system.img | cut -f 1`
sudo bin/make_ext4fs -T 0 -S rom/file_contexts -l $imgSize -a system rom/system_new.img output/

echo 'Unmounting file system'
sudo umount output/
rmdir output/

echo 'Converting raw image to sparse image'
bin/img2simg rom/system_new.img rom/system.sparse.img

echo 'Cleaning original files'
rm -f rom/file_contexts.bin rom/file_contexts rom/system.transfer.list rom/system.new.dat rom/system.img rom/system_new.img

echo 'Converting sparse image to sparse data'
echo '4' | bin/img2sdat.py -o rom/ rom/system.sparse.img

newName="${romFileName}_new.${romFileExt}"
echo "Copying original zip to $newName"
cp "$romFilePath" "rom/$newName"

echo 'Modifying new zip'
cd rom
apack "$newName" system.new.dat system.patch.dat system.transfer.list

mv "$newName" ..
cd ..
rm -rf rom
echo 'Done'
