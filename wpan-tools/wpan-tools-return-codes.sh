#!/bin/bash

iwpan_positive_testing()
{
	echo "#####     iwpan positive testing     #####"

	# Test with wpan0 down
	ip link set wpan0 down
	# Show tested iwpan version
	iwpan --version
	if [ $? -ne 0 ]
	then
		echo "Test failure"
		exit
	fi
	# Test phy commands
	iwpan phy phy0 set cca_ed_level -77
	if [ $? -ne 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan phy phy0 set cca_mode 1
	if [ $? -ne 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan phy phy0 set tx_power 4
	if [ $? -ne 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan phy phy0 set channel 0 13
	if [ $? -ne 0 ]
	then
		echo "Test failure"
		exit
	fi

	# Test dev commands
	iwpan dev wpan0 set ackreq_default 0
	if [ $? -ne 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan dev wpan0 set lbt 0
	if [ $? -ne 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan dev wpan0 set max_csma_backoffs 4
	if [ $? -ne 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan dev wpan0 set backoff_exponents 3 5
	if [ $? -ne 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan dev wpan0 set max_frame_retries 3
	if [ $? -ne 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan dev wpan0 set short_addr 0x0001
	if [ $? -ne 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan dev wpan0 set pan_id 0xbeef
	if [ $? -ne 0 ]
	then
		echo "Test failure"
		exit
	fi

	# Test misc commands
#	iwpan phy
#	iwpan list
#	iwpan phy phy0 info
#	iwpan dev
#	iwpan dev wpan0 info

	# Test delete and create commands
#	iwpan dev wpan0 del
#	iwpan phy phy0 interface add wpan0 type node DE:AD:BE:EF:BA:BE:00:01
}

iwpan_negative_testing()
{
	echo "#####     iwpan negative testing     #####"

	# Test with wpan0 down
	ip link set wpan0 down
	# Show tested iwpan version
	iwpan --versions 2>&1 > /dev/null
	if [ $? -eq 0 ]
	then
		echo "Test failure"
		exit
	fi
	# Test phy commands
	iwpan phy phy0 set cca_ed_level -3000
	if [ $? -eq 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan phy phy0 set cca_mode 10
	if [ $? -eq 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan phy phy0 set tx_power 400
	if [ $? -eq 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan phy phy0 set channel 30 400
	if [ $? -eq 0 ]
	then
		echo "Test failure"
		exit
	fi

	# Test dev commands
	iwpan dev wpan0 set ackreq_default 256
	if [ $? -eq 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan dev wpan0 set lbt 400
	if [ $? -eq 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan dev wpan0 set max_csma_backoffs 400
	if [ $? -eq 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan dev wpan0 set backoff_exponents 30 400
	if [ $? -eq 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan dev wpan0 set max_frame_retries 400
	if [ $? -eq 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan dev wpan0 set short_addr 0xffff 2>&1 > /dev/null
	if [ $? -eq 0 ]
	then
		echo "Test failure"
		exit
	fi
	iwpan dev wpan0 set pan_id 0xffff 2>&1 > /dev/null
	if [ $? -eq 0 ]
	then
		echo "Test failure"
		exit
	fi

	# Test misc commands
#	iwpan phy
#	iwpan list
#	iwpan phy phy0 info
#	iwpan dev
#	iwpan dev wpan0 info

	# Test delete and create commands
#	iwpan dev wpan0 del
#	iwpan phy phy0 interface add wpan0 type node DE:AD:BE:EF:BA:BE:00:01

# Test all the wpan-ping options and commands
}

iwpan_positive_testing
iwpan_negative_testing
