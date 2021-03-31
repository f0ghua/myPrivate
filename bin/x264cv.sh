#!/bin/bash
## This script started life as ipodvidenc - The iPod Video Encoder for Linux.
## Created by Eric Hewitt, January 9, 2006.
## Released under the GPL.  Go nuts.
## Edited, renamed and updated by Phill Clarke, December 17, 2007

## This section determines the output filename, dimensions, bitrate and location.

input_file=$1

echo "What would you like to name the output file (sans extension)?"

read output_file_name

echo "What video codec would you like to use for your new file? Please select by typing a number"

OPTIONS="x264 xvid"
select video_codec in $OPTIONS; do
	if [ "$video_codec" = "x264" ]; then
		output_video_codec="libx264"
		echo "OK, we'll use x264 for H264 encoding"
		echo "What extension would you like to give this file? Please select by typing a number"
		OPTIONS="mov mp4 3gp avi"
		select video_opt in $OPTIONS; do
			if [ "$video_opt" = "mov" ]; then
			output_file_extension="mov"
			echo "OK, we'll use $video_opt as the file extension"
			break
			elif [ "$video_opt" = "mp4" ]; then
			output_file_extension="mp4"
			echo "OK, we'll use $video_opt as the file extension"
			break
			elif [ "$video_opt" = "3gp" ]; then
			output_file_extension="3gp"
			echo "OK, we'll use $video_opt as the file extension"
			break
			elif [ "$video_opt" = "avi" ]; then
			output_file_extension="avi"
			echo "OK, we'll use $video_opt as the file extension"
			break
			else
			echo "Sorry, you haven't chosen a valid option"
			exit
			fi
		done
		echo "Which audio codec would you like to use for output? Please select by typing a number."
		OPTIONS="aac mp3 flac"
		select audio_opt in $OPTIONS; do
			if [ "$audio_opt" = "aac" ]; then
			output_file_audiocodec="libfaac"
			echo "OK, we'll use $audio_opt for audio"
			break
			elif [ "$audio_opt" = "mp3" ]; then
			output_file_audiocodec="libmp3lame"
			echo "OK, we'll use $audio_opt for audio"
			break
			elif [ "$audio_opt" = "flac" ]; then
			output_file_audiocodec="flac"
			echo "OK, we'll use $audio_opt for audio"
			break
			else
			echo "Sorry, you haven't chosen a valid option"
			exit
			fi
		done
	break
	elif [ "$video_codec" = "xvid" ]; then
		output_video_codec="libxvid"
		echo "OK, we'll use xvid for MPEG4 encoding"
		echo "What extension would you like to give this file? Please select by typing a number"
		OPTIONS="mov mp4 3gp avi"
		select video_opt in $OPTIONS; do
			if [ "$video_opt" = "mov" ]; then
			output_file_extension="mov"
			echo "OK, we'll use $video_opt as the file extension"
			break
			elif [ "$video_opt" = "mp4" ]; then
			output_file_extension="mp4"
			echo "OK, we'll use $video_opt as the file extension"
			break
			elif [ "$video_opt" = "3gp" ]; then
			output_file_extension="3gp"
			echo "OK, we'll use $video_opt as the file extension"
			break
			elif [ "$video_opt" = "avi" ]; then
			output_file_extension="avi"
			echo "OK, we'll use $video_opt as the file extension"
			break
			else
			echo "Sorry, you haven't chosen a valid option"
			exit
			fi
		done
		echo "Which audio codec would you like to use for output? Please select by typing a number."
		OPTIONS="aac mp3 flac"
		select audio_opt in $OPTIONS; do
			if [ "$audio_opt" = "aac" ]; then
			output_file_audiocodec="libfaac"
			echo "OK, we'll use $audio_opt for audio"
			break
			elif [ "$audio_opt" = "mp3" ]; then
			output_file_audiocodec="libmp3lame"
			echo "OK, we'll use $audio_opt for audio"
			break
			elif [ "$audio_opt" = "flac" ]; then
			output_file_audiocodec="flac"
			echo "OK, we'll use $audio_opt for audio"
			break
			else
			echo "Sorry, you haven't chosen a valid option"
			exit
			fi
		done
	break
	else
	echo "Sorry, you haven't chosen a valid option"
	exit
	fi
done

echo "What would you like the new video width to be? Multiples of 16 are best e.g. 720, 640, 320"

read output_file_width

echo "What would you like the new video height to be? Make sure this is sensible with your width e.g. 640x480 or 320x240"

read output_file_height

echo "What would you like the output file video bitrate to be, in kilobits per second? e.g. 500k"

read output_file_bitrate

echo "What would you like the output file audio bitrate to be, in kilobits per second? e.g. 96k or 128k"

read output_file_audiorate

## Ask if the file needs cropping. This is currently only done in the second pass.

echo "Do you need to crop this file? [y/n]"

read output_crop_permis

if [ $output_crop_permis = 'y' ] || [ $output_crop_permis = 'Y' ]
then
	echo "Please enter the number of pixels you'd like to crop from the top of your file. Enter 0 for none."

	read output_crop_top

	echo "Please enter the number of pixels you'd like to crop from the bottom of your file. Enter 0 for none."

	read output_crop_bottom

	echo "Please enter the number of pixels you'd like to crop from the left of your file. Enter 0 for none."

	read output_crop_left

	echo "Please enter the number of pixels you'd like to crop from the right of your file. Enter 0 for none."

	read output_crop_right
else
	echo "OK, no cropping will be performed."

fi

## Where will the new file be saved?

echo "$output_file_name.$output_file_extension will be located in $PWD. Is this acceptable? [y/n]"

read output_file_loc_permis

if [ $output_file_loc_permis = 'n' ] || [ $output_file_loc_permis = 'N' ]
then
        echo "Where would you like to store $output_file_name.$output_file_extension?"
        read output_dir
else
        output_dir=$PWD
fi

## Confirm details of new file

echo "You have entered the following details for your new file:"
echo "New file video codec: $video_codec"
echo "New filename: $output_file_name.$output_file_extension"
echo "New file width: $output_file_width"
echo "New file height: $output_file_height"
echo "New file video bitrate: $output_file_bitrate kbps"
echo "New file audio codec: $audio_opt"
echo "New file audio bitrate: $output_file_audiorate kbps"
if [ $output_crop_permis = 'y' ] || [ $output_crop_permis = 'Y' ]
then
	echo "You are cropping $output_crop_top pixels from the top of your input file"
	echo "You are cropping $output_crop_bottom pixels from the bottom of your input file"
	echo "You are cropping $output_crop_left pixels from the left of your input file"
	echo "You are cropping $output_crop_right pixels from the right of your input file"
else
	echo "No cropping will be performed"
fi
echo "New file will be saved in the following location: $output_dir"
echo "Are these details correct? [y/n]"

read output_file_confirm

if [ $output_file_confirm = 'n' ] || [ $output_file_confirm = 'N' ]
then
	echo "OK, then please try again...."
	exit
else
	echo "Excellent. Your file will now be created. Please be patient."
fi

## Pass one for H264 files

ffmpeg -y -i ${input_file} -an -v 1 -threads auto -vcodec ${output_video_codec} -b ${output_file_bitrate} -bt 175k -refs 1 -loop 1 -deblockalpha 0 -deblockbeta 0 -parti4x4 1 -partp8x8 1 -me full -subq 1 -me_range 21 -chroma 1 -slice 2 -bf 0 -level 30 -g 300 -keyint_min 30 -sc_threshold 40 -rc_eq 'blurCplx^(1-qComp)' -qcomp 0.7 -qmax 51 -qdiff 4 -i_qfactor 0.71428572 -maxrate ${output_file_bitrate} -bufsize 2M -cmp 1 -s ${output_file_width}x${output_file_height} -f ${output_file_extension} -pass 1 /dev/null

## Pass Two for H264 files

ffmpeg -y -i ${input_file} -v 1 -threads auto -vcodec ${output_video_codec} -b ${output_file_bitrate} -bt 175k -refs 1 -loop 1 -deblockalpha 0 -deblockbeta 0 -parti4x4 1 -partp8x8 1 -me full -subq 6 -me_range 21 -chroma 1 -slice 2 -bf 0 -level 30 -g 300 -keyint_min 30 -sc_threshold 40 -rc_eq 'blurCplx^(1-qComp)' -qcomp 0.7 -qmax 51 -qdiff 4 -i_qfactor 0.71428572 -maxrate ${output_file_bitrate} -bufsize 2M -cmp 1 -s ${output_file_width}x${output_file_height} -croptop ${output_crop_top} -cropbottom ${output_crop_bottom} -cropleft ${output_crop_left} -cropright ${output_crop_right} -acodec ${output_file_audiocodec} -ab ${output_file_audiorate} -ar 48000 -ac 2 -f ${output_file_extension} -pass 2 ${output_dir}/${output_file_name}.${output_file_extension}

echo "Your file has been created." 

## If a QuickTime file, is Fast Start to be applied.

if [ $output_file_extension = 'mov' ] || [ $output_file_extension = 'mp4' ]
then
	echo "Would you like to apply qt-faststart? [y/n]"
	read qt_faststart_permis
	
	if [ $qt_faststart_permis = 'y' ] || [ $qt_faststart_permis = 'Y' ]
	then
		mv ${output_dir}/${output_file_name}.${output_file_extension} ${output_dir}/${output_file_name}_temp.${output_file_extension}
		qt-faststart ${output_dir}/${output_file_name}_temp.${output_file_extension} ${output_dir}/${output_file_name}.${output_file_extension}

		echo "QuickTime fast start applied"
		rm ${output_dir}/${output_file_name}_temp.${output_file_extension}
		echo "OK, we're finished."
	else
		echo "OK, we're finished"
	fi
else
	echo "OK, we're finished"
fi
