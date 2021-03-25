#!/bin/bash

THIS=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`
DIR=`dirname "${THIS}"`

help () {
	cat $DIR/help
	exit 1
}

defaultvalues () {
	directory="output"
	verbose=""
	ports=""
	flags=""
}

#Method to check that first argument starts with -
checkcommandformat () {
	if [[ $1 != -* ]]; then
		echo "Please check argument \"$1\", it is not a command option."
		help
	fi
	if [[ $2 == -* ]]; then
		echo "Please check argument \"$2\", it should not be a command option."
		help
	fi
}


addflag () {
	if [[ -z $flags ]]; then
		flags="$1";
	else
		flags="$flags $1"
	fi
}

#Interpreter for arguments an corresponding action
getcommand () {
	#include everything from createargs/code

if [[ $1 == -f || $1 == -F ]]; then file=$2; fi
if [[ $1 == -u || $1 == -U ]]; then hostname=$2; fi
if [[ $1 == -d || $1 == -D ]]; then directory=$2; fi

}


#Method to parse the commands with arguments
argparse () {
	if [ -z $# ]; then echo "something went wrong at argparse"; exit 1; fi
	checkcommandformat $1 $2
	getcommand $1 $2
}

#Method to parse the flags
flagparse () {
if [ -z $# ]; then echo "something went wrong at flagparse"; exit 1; fi

if [[ $1 == -v || $1 == -V ]]; then verbose="-v"; fi
if [[ $1 == -q || $1 == -Q ]]; then ports="-q"; fi
if [[ $1 == -qq|| $1 == -QQ ]]; then ports="-qq"; fi
if [[ $1 == -Pn ]]; then
	addflag "-Pn"
fi

}

looparg () {
	#Loop through all arguments.
	while (( "$#" >= 1 )); do
		if [[ "$#" == 1 ]]; then
			flagparse $1
			shift
		else
			if [[ $1 == -* && $2 == -* ]]; then
				if [[ $1 == -n ]]; then
					nmapoption=$@
					shift $#
				else
					flagparse $1
					shift 1
				fi
			else
				argparse $1 $2
				shift 2
			fi
		fi
	done
}

dirformat () {
	#Check that the directory is well formatted with a / at the end.	
	if [[ -n $directory ]]; then
		if [[ $directory == *// ]]; then
			directory=$(echo $directory | rev | cut -d "/" -f2- | rev)
		elif [[ $directory != */ ]]; then
			directory="$directory/"
		fi
		if [[ ! -s $directory ]]; then
			mkdir -p $directory
		fi
	else
		directory="./"
	fi
}

#Module to change path used for saving files
changepath () {
	path=$directory$1
	if [[ $path != */ ]]; then path+="/"; fi
	mkdir -p $path
}


#call stdcheck-network
networkscan () {
	$DIR/netchecker/netchecker.sh -d $directory $1 $ports $verbose $flags $nmapoption
}

#call stdcheck-web
webscan () {
	for web in $(cat $directory/$1.http.ips.ports $directory/$1.https.hostnames.ports); do
		webhost=$(echo $web | cut -d "/" -f3 | cut -d ":" -f1)
		webport=$(echo $web | cut -d "/" -f3 | cut -d ":" -f2)
		webname="$webhost-$webport"
		webdir="${directory}webchecker/${webname}"
		
		mkdir -p $webdir
		python3 $DIR/webchecker/webchecker.py -dr $webdir -u $web
	done
}


urlinput () {
	networkscan "-u $hostname"
	webscan $hostname
}

fileinput () {
	networkscan "-f $file"
	webscan $file
}



main () {
	defaultvalues
	looparg $@
	dirformat
	
	if [ -n "$hostname" ]; then
		urlinput
	elif [ -n "$file" ]; then
		fileinput
	else
		help
	fi
}
main $@


























