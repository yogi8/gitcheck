#!/bin/bash

vid="media_b1300000_%s.ts"
vod="/*.ts"
vidtool="mkvmerge -o"
sep=" + "
vids=()

function Usage()
{
	echo "Usage Function"
	cat << HELP_TEXT
	usage: $0 <No of files / last file number> <Source Dir> <Destination Full Path + Filename>
	     : $0 3 /home/ubuntu /home/finaldir/finalvid.ts
HELP_TEXT
	exit 1
}

function ParseParam()
{
	echo "ParseParam Function"
	echo $#
	if [ "$#" -ne 3 ];then
		echo "ERROR! Please provide correct parameters for the script."
		Usage
	fi
}

function DoFileExist()
{
	echo "DoFileExist Function"
	for i in $(seq 0 $1);do
		red=`printf "$vid" $i`
		vids[${#vids[@]}]=$red
	done
	for i in ${vids[@]};do
		if [ -f $2/$i ];then
			echo "$i exists"
			continue
		else
			echo "$i not exists"
			return 1
		fi
	done
}

function DeleteFiles()
{
	echo "DeleteFiles Function"
	directorye=$1
	directorye+=$vod
	echo $directorye
	#rm -rf $directorye
}

function CommandMaker()
{
	echo "CommandMaker Function"
	destfile=$1
	printf -v result '%s' "${vids[@]/#/$sep}";
	#echo $result
	printf -v final '%s' "${result:${#sep}}"
	#echo $final
	printf -v cmd '%s ' "${vidtool}" "${1}" "${final}"
	echo $cmd
}

function CommandExecuter()
{
	echo "CommandExecuter Function"
	DoFileExist $1 $2 && echo "All Files Exist"
	#echo $?
	if [ $? != 0 ];then
		echo "Few Files are missing"
		echo "Deleting All Files"
		DeleteFiles $2
		exit 1
	fi
	CommandMaker $3
	cd $2
	eval $cmd
	#echo $?
	#exit 0
	if [ $? != 0 ];then
		echo "Command Execution Failed"
		exit 1
	fi
	echo "Command Executed Successfully"
	echo "Deleting All Files"
	DeleteFiles $2
	
}

ParseParam "$@"
CommandExecuter "$@"



#DoFileExist 2
#CommandMaker /home/yogi88/maker.ts
#DeleteFiles /home/yogi88


#https://superuser.com/questions/461981/how-do-i-convert-a-bash-array-variable-to-a-string-delimited-with-newlines/462400
