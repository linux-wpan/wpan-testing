#!/bin/bash

DEST=$1

# Configuration
DEST_SHORT=0x000$DEST
DEST_LONG=DE:AD:BE:EF:BA:BE:00:0$DEST
COUNT=10

wpan_ping_testing()
{
	read -p "Start wpan-ping -d on other side now" -n1 -s

	echo -e "\r"
	echo "#####     IEEE 802.15.4 connection testing     #####"

	# Minimum wpan-ping size to get timing information
	wpan-ping -a $DEST_SHORT -c $COUNT  -s 5
	echo "6-7 ms average time expected"
	echo -e "\r"

	# Maximum wpan-ping size to get timing information
	wpan-ping --address $DEST_SHORT --count $COUNT  --size 104
	echo "13 - 14 ms average time expected"
	echo -e "\r"

	# Minimum wpan-ping size to get timing information
	wpan-ping -e -a $DEST_LONG -c $COUNT  -s 5
	echo "6-7 ms average time expected"
	echo -e "\r"

	# Maximum wpan-ping size to get timing information
	wpan-ping --extended --address $DEST_LONG --count $COUNT  --size 104
	echo "13 - 14 ms average time expected"
	echo -e "\r"
}

if [ -z "$DEST" ]
then
	echo "Node number as parameter needed"
	exit
fi

wpan_ping_testing
