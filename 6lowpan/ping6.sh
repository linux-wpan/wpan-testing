#!/bin/bash

DEST=$1

# Configuration
DEST_IPV6=fe80::dcad:beef:babe:$DEST
COUNT=10

ping6_testing()
{
	read -p "Stop wpan-ping -d on other side to avoid problems with 6lowpan measurements" -n1 -s

	echo -e "\r"
	echo "#####     6LoWPAN connection testing     #####"

	# Default ping packet size (56 + 8), one frame transmitted
	ping6 -I lowpan0 -c $COUNT $DEST_IPV6
	echo "10 - 11 ms average time expected"
	echo -e "\r"

	# Minimum ping size (8 + 8) to get timing information, one frame transmitted
	ping6 -I lowpan0 -c $COUNT -s 8 $DEST_IPV6
	echo "7 - 8 ms average time expected"
	echo -e "\r"

	# Maximum size (?? + 8) to fit into one frame, one frame transmitted
	#ping6 -I lowpan0 -c $COUNT -s 8 $DEST_IPV6

	# Minimum size (?? + 8) to need two frames, two frames transmitted
	#ping6 -I lowpan0 -c $COUNT -s 8 $DEST_IPV6

	ping6 -I lowpan0 -c $COUNT -s 2000 $DEST_IPV6
	echo "230 - 240 ms average time expected"

	#ping6 -I lowpan0 -c $COUNT -s 8000 $DEST_IPV6
	#echo "920 - 930 ms average time expected"
}

if [ -z "$DEST" ]
then
	echo "Node number as parameter needed"
	exit
fi

ping6_testing
