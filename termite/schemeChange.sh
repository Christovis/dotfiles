#!/bin/bash
#
# _____                  _____                   _ _       
#| ____|__ _ ___ _   _  |_   _|__ _ __ _ __ ___ (_) |_ ___ 
#|  _| / _` / __| | | |   | |/ _ \ '__| '_ ` _ \| | __/ _ \
#| |__| (_| \__ \ |_| |   | |  __/ |  | | | | | | | ||  __/
#|_____\__,_|___/\__, |   |_|\___|_|  |_| |_| |_|_|\__\___|
#                |___/                                     
#  ____       _                          ____ _                                 
# / ___|  ___| |__   ___ _ __ ___   ___ / ___| |__   __ _ _ __   __ _  ___ _ __ 
# \___ \ / __| '_ \ / _ \ '_ ` _ \ / _ \ |   | '_ \ / _` | '_ \ / _` |/ _ \ '__|
#  ___) | (__| | | |  __/ | | | | |  __/ |___| | | | (_| | | | | (_| |  __/ |   
# |____/ \___|_| |_|\___|_| |_| |_|\___|\____|_| |_|\__,_|_| |_|\__, |\___|_|   
#
# -----------------------------------------------------------------------------
# Simple Script to switch between color schemes for termite
#
# Usage:   schemeChange.sh -[Option] [SchemeName]
# 			-l --list	List available color schemes
#			-h --help	Bring up the current help dialouge
# 			-c --change	Change the scheme the one of the available schemes
# 			-v --view	Preview an available color scheme
# -----------------------------------------------------------------------------
# To change font color go to .config/nvim/init.nvim

# Location of config and scheme files.
# Make sure scheme files are are present
# next to the config file
#
# Scheme files should follow format "$name.scheme"
#
# Location must be ABSOLUTE PATH

config_loc="/home/christoph/.config/termite/"
config_name="config"

# Scheme Location: Uncomment one of the two lines below
scheme_loc=$config_loc

if [ ! -w $config_loc$config_name ]
then
	echo "CANNOT READ YOUR TERMITE CONFIG FILE"
	echo "Please modify the location in the source file"
	echo "Look for variables config_loc and config_name"
	echo ""
	exit 1
fi

# start_line holds the information of where [colors] is located.
# ALL data stored after [colors] will be erased.
# Ensure all non-color-scheme based data are written before the [color] block
# i.e. [colors] should be the last block in ~/.config/termite/config

start_line=$( cat $config_loc$config_name | grep -n -m 1 "\[colors\]" | tr -d ":\[colors\]" )

# List of available schemes found in folder

scheme_list=$( ls $scheme_loc | grep ".scheme" )


# error/help Message
# Displays usage information and if there was an error

errMessage () {
	echo ""
	if [ $1 == "true" ]
	then
		echo "Error: Incorrect Usage!"
	fi
	echo ""
	echo "	USAGE : schemeChange.sh -[Option] [SchemeName]"
	echo ""
	echo "		-l --list	List available color schemes"
	echo ""
	echo "		-h --help	Bring up the current help dialouge"
	echo ""
	echo "		-c --change	Change the scheme the one of the available schemes"
	echo ""
	echo "		-v --view	Preview an available color scheme"
	echo ""
	return
}


# Main if statement.
# returns error if no arg found
# can display list of schemes
# will set scheme

if [ -z $1 ]
then
	echo "No parameters found!!!"
	errMessage "true"
	exit 1

elif [ $1 == "-l" -o $1 == "--list" ]
then
	for item in $scheme_list
	do
		echo -e "$item"
	done
	exit 0

elif [ $1 == "-h" -o $1 == "--list" ]
then
	errMessage "false"
	exit 0

elif [ $1 == "-c" -o $1 == "--change" ]
then
	if [ ! -r $scheme_loc$2 ]
	then
		echo ""
		echo "File does not exist or it is not writable."
		errMessage "true"
		exit 1
	fi
	
	if [ -z $( echo $2 | grep ".scheme" ) ]
	then
		echo ""
		echo "NOT A SCHEME FILE!"
		echo "Please use a file named scheme.\$name"
		echo "If it is a scheme file, please rename."
		errMessage "true"
		exit 1
	fi
	delete_range=$((start_line+1))
	delete_range=$delete_range,\$d
	echo "[colors] found at   : " $start_line
	echo "Range to be deleted : " $delete_range
	cat $(sed -e $delete_range $config_loc$config_name > .schch.temp) .schch.temp $scheme_loc$2 > $config_loc$config_name 
	rm .schch.temp
	echo "Scheme Changed to "$2
	exit 0

elif [ $1 == "-v" -o $1 == "--view" ]
then
	echo "Viewing Color Scheme!"

else
	echo ""
	echo "Invalid Option"
	errMessage "true"
	exit 1
fi

echo "True End"
