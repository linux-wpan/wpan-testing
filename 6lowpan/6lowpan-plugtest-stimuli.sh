#!/bin/bash

EUT=$1

# Configuration
CHANNEL=26
PANID=0xbeef

EUT1_SHORT=0x0001
EUT1_EXTENDED=DE:AD:BE:EF:BA:BE:00:01
EUT1_IPV6=2001:db8:dead:beef::1

EUT2_SHORT=0x0002
EUT2_EXTENDED=DE:AD:BE:EF:BA:BE:00:02
EUT2_IPV6=2001:db8:dead:beef::2

# One kernel with compression compiled in and one without?
# Run installed CoAP ping server
# Run installed HTTP server

setup_device()
{
	iwpan dev wpan0 del
	iwpan phy phy0 interface add wpan0 type node DE:AD:BE:EF:BA:BE:00:0$EUT
	ip link set wpan0 down
	iwpan phy phy0 set channel 0 $CHANNEL
	iwpan dev wpan0 set ackreq_default 1
	iwpan dev wpan0 set pan_id $PANID
	iwpan dev wpan0 set short_addr 0x000$EUT
	ip link add link wpan0 name lowpan0 type lowpan
	#sysctl net.ipv6.conf.lowpan0.accept_dad=0
	#ip addr add 2001:db8:dead:beef::$EUT/64 dev lowpan0
	ip link set wpan0 up
	ip link set lowpan0 up
}

disable_header_compression()
{
	echo "Disable header compression"
}

enable_header_compression()
{
	echo "Enable header compression"
}

setup_address_eui64()
{
	echo "Setup address with EUI64"
}

setup_address_short()
{
	echo "Setup address with short address"
}

test_case_01()
{
	echo "================================================================================="
	echo "TD_6Lo_FORMAT_01"
	echo "Check that EUTs correctly handle uncompressed 6LoWPAN packets (EUI-64 link-local)"
	echo "---"
	echo "Header compression is disabled on both EUT1 and EUT2"
	echo "EUT1 and EUT2 are configured to use EUI-64"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	disable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2
	fi
}

test_case_02()
{
	echo "================================================================================="
	echo "TD_6Lo_FORMAT_02"
	echo "Check that EUTs correctly handle uncompressed 6LoWPAN packets (16-bit short link-local)"
	echo "---"
	echo "Header compression is disabled on both EUT1 and EUT2"
	echo "EUT1 and EUT2 are configured to use 16-bit short address"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	disable_header_compression
	setup_address_short

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2 #adapt to short address format
	fi
}

test_case_03()
{
	echo "================================================================================="
	echo "TD_6Lo_FORMAT_03"
	echo "Check that EUTs correctly handle uncompressed 6LoWPAN fragmented packets"
	echo "---"
	echo "Header compression is disabled on both EUT1 and EUT2"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	disable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 253 fe80::dcad:beef:babe:2
	fi
}

test_case_04()
{
	echo "================================================================================="
	echo "TD_6Lo_FORMAT_04"
	echo "Check that EUTs correctly handle maximum size uncompressed 6LoWPAN fragmented packets"
	echo "---"
	echo "Header compression is disabled on both EUT1 and EUT2"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	disable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 1232 fe80::dcad:beef:babe:2
	fi
}

test_case_05()
{
	echo "================================================================================="
	echo "TD_6Lo_FORMAT_05"
	echo "Check that EUTs correctly handle uncompressed 6LoWPAN multicast to all-nodes (16-bit short link-local)"
	echo "---"
	echo "Header compression is disabled on both EUT1 and EUT2"
	echo "EUT1 and EUT2 are configured to use 16-bit short address"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	disable_header_compression
	setup_address_short

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 4 ff02::1
	fi
}

test_case_06()
{
	echo "================================================================================="
	echo "TD_6Lo_FORMAT_06"
	echo "Check that EUTs correctly handle uncompressed 6LoWPAN multicast to all-nodes (EUI-64 link-local)"
	echo "---"
	echo "Header compression is disabled on both EUT1 and EUT2"
	echo "EUT1 and EUT2 are configured to use EUI-64"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	disable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 4 ff02::1
	fi
}

test_case_07()
{
	echo "================================================================================="
	echo "TD_6Lo_FORMAT_07"
	echo "Check that EUTs correctly handle uncompressed 6LoWPAN packets (EUI-64 to 16-bit short link-local)"
	echo "---"
	echo "Header compression is disabled on both EUT1 and EUT2"
	echo "EUT1 is configured to use EUI-64 and EUT2 is configured to use 16-bit short address"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	disable_header_compression

	if [ $EUT == 1 ]
	then
		setup_address_eui64
	fi
	if [ $EUT == 2 ]
	then
		setup_address_short
	fi

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2 #adapt to short address format
	fi
}

test_case_08()
{
	echo "================================================================================="
	echo "TD_6Lo_FORMAT_08"
	echo "Check that EUTs correctly handle uncompressed 6LoWPAN packets (16-bit short to EUI-64 link-local)"
	echo "---"
	echo "Header compression is disabled on both EUT1 and EUT2"
	echo "EUT1 is configured to use 16-bit short address and EUT2 is configured to use EUI-64"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	disable_header_compression

	if [ $EUT == 1 ]
	then
		setup_address_short
	fi
	if [ $EUT == 2 ]
	then
		setup_address_eui64
	fi

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2
	fi
}

test_case_09()
{
	echo "No 6LoBAC suport"
}

test_case_10()
{
	echo "================================================================================="
	echo "TD_6Lo_HC_01"
	echo "Check that EUTs correctly handle compressed 6Lo packets (EUI-64 or other long address link-local, hop limit=64)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both EUT1 and EUT2"
	echo "EUT1 and EUT2 are configured to use EUI-64 or other long address"
	echo "EUT1 and EUT2 are configured with a default hop limit of 64"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2
		# Set hop limit to 64, no traffic class or flow label is being used
	fi
}

test_case_11()
{
	echo "================================================================================="
	echo "TD_6Lo_HC_02"
	echo "Check that EUTs correctly handle compressed 6Lo packets (16-bit or other short address link-local, hop limit=64)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both EUT1 and EUT2"
	echo "EUT1 and EUT2 are configured to use 16-bit or other short address"
	echo "EUT1 and EUT2 are configured with a default hop limit of 64"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_short

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2 #adapt to short address format
		# Set hop limit to 64, no traffic class or flow label is being used
	fi
}

test_case_12()
{
	echo "================================================================================="
	echo "TD_6Lo_HC_03"
	echo "Check that EUTs correctly handle compressed 6Lo packets (EUI-64 or other long address link-local, hop limit=63)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both EUT1 and EUT2"
	echo "EUT1 and EUT2 are configured to use EUI-64 or other long address"
	echo "EUT1 and EUT2 are configured with a default hop limit of 63"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2
		# Set hop limit to 63, no traffic class or flow label is being used
	fi
}

test_case_13()
{
	echo "================================================================================="
	echo "TD_6Lo_HC_04"
	echo "Check that EUTs correctly handle compressed 6Lo packets (16-bit or other short address link-local, hop limit=63)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both EUT1 and EUT2"
	echo "EUT1 and EUT2 are configured to use 16-bit or other short address"
	echo "EUT1 and EUT2 are configured with a default hop limit of 63"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_short

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2 #adapt to short address format
		# Set hop limit to 63, no traffic class or flow label is being used
	fi
}

test_case_14()
{
	echo "================================================================================="
	echo "TD_6Lo_HC_05"
	echo "Check that EUTs correctly handle compressed UDP packets (EUI-64 or other long address, server port 5683)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "Host is configured to use EUI-64 address"
	echo "A CoAP ping server is installed on port 5683 of the host"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		echo "No CoAP ping support yet"
	fi
}

test_case_15()
{
	echo "================================================================================="
	echo "TD_6Lo_HC_06"
	echo "Check that EUTs correctly handle compressed UDP packets (16-bit or other short address, server port 5683)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "Host is configured to use 16-bit address"
	echo "A CoAP ping server is installed on port 5683 of the host"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_short

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		echo "No CoAP ping support yet"
	fi
}

test_case_16()
{
	echo "================================================================================="
	echo "TD_6Lo_HC_07"
	echo "Check that EUTs correctly handle compressed UDP packets (EUI-64 or other long address, server port 61616)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "Host is configured to use EUI-64 address"
	echo "A CoAP ping server is installed on port 61616 of the host"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		echo "No CoAP ping support yet"
	fi
}

test_case_17()
{
	echo "================================================================================="
	echo "TD_6Lo_HC_08"
	echo "Check that EUTs correctly handle compressed UDP packets (16-bit or other short address, server port 61616)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "Host is configured to use 16-bit address"
	echo "A CoAP ping server is installed on port 61616 of the host"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_short

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		echo "No CoAP ping support yet"
	fi
}

test_case_18()
{
	echo "================================================================================="
	echo "TD_6Lo_HC_09"
	ecgo "Check that EUTs correctly handle compressed 6LoWPAN packets (EUI-64 or other long address to 16-bit or other short address link-local, hop limit=64)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both EUT1 and EUT2"
	echo "EUT1 is configured to use EUI-64 and EUT2 is configured to use 16-bit short address"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression

	if [ $EUT == 1 ]
	then
		setup_address_eui64
	fi
	if [ $EUT == 2 ]
	then
		setup_address_short
	fi

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2 #adapt to short address format
		# Set hop limit to 64, no traffic class or flow label is being used
	fi
}

test_case_19()
{
	echo "================================================================================="
	echo "TD_6Lo_HC_10"
	ecgo "Check that EUTs correctly handle compressed 6LoWPAN packets (16-bit or other short address to EUI-64 or other long address link-local, hop limit=64)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both EUT1 and EUT2"
	echo "EUT1 is configured to use 16-bit short address and EUT2 is configured to use EUI-64 address"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression

	if [ $EUT == 1 ]
	then
		setup_address_short
	fi
	if [ $EUT == 2 ]
	then
		setup_address_eui64
	fi

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2
		# Set hop limit to 64, no traffic class or flow label is being used
	fi
}

test_case_20()
{
	echo "================================================================================="
	echo "TD_6Lo_HC_11"
	echo "Check that EUTs correctly handle NH=0 compressed TCP packets (EUI-64 or other long address)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "Host is configured to use EUI-64 address"
	echo "A TCP server (e.g., a HTTP server) is installed on port 80 of the host"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		echo "No TCP SYN request support yet"
	fi
}

test_case_21()
{
	echo "================================================================================="
	echo "TD_6Lo_HC_12"
	echo "Check that EUTs correctly handle NH=0 compressed TCP packets (16-bit or other short address)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "Host is configured to use 16-bit address"
	echo "A TCP server (e.g., a HTTP server) is installed on port 80 of the host"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_short

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		echo "No TCP SYN request support yet"
	fi
}

test_case_22()
{
	echo "================================================================================="
	echo "TD_6Lo_ND_01"
	echo "Check that a host is able to register its global IPv6 address (EUI-64 or other long address)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "Host is configured to use EUI-64 or other long address"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		echo "No stimulus needed, just watch ND address handling in wireshark"
	fi
}

test_case_23()
{
	echo "================================================================================="
	echo "TD_6Lo_ND_02"
	echo "Check that a host is able to register its global IPv6 address (16-bit or other short address)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "Host is configured to use 16-bit or other short address"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_short

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		echo "No stimulus needed, just watch ND address handling in wireshark"
	fi
}

test_case_24()
{
	echo "================================================================================="
	echo "TD_6Lo_ND_03"
	echo "Check Host NUD behavior"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "Host is up and registered its global address with the Router"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 2001:db8::1
	fi
}

test_case_25()
{
	echo "================================================================================="
	echo "TD_6Lo_ND_04"
	echo "Check Host NUD behavior (ICMP version)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "Host is up and registered its global address with the Router"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		ping6 -I lowpan0 -c 1 fe80::dcad:beef:babe:2
		# Disable echo reply after 10s on host	 
	fi
}

test_case_26()
{
	echo "================================================================================="
	echo "TD_6Lo_ND_05"
	echo "Check Host NUD behavior (UDP version)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "A CoAP ping server is installed on port 5683 of the host"
	echo "Host is up and registered its global address with the Router"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		echo "No CoAP ping support yet"
		# Disable echo reply after 10s on host	 
	fi
}

test_case_27()
{
	echo "================================================================================="
	echo "TD_6Lo_ND_06"
	echo "Check host behavior under multiple prefixes (EUI-64 or other long address)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "Host is configured to use EUI-64 or other long address"
	echo "Router is configured with multiple prefixes"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_eui64
	# Setup multiple prefixes

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		echo "No stimulus needed, just watch ND address handling in wireshark"
	fi
}

test_case_28()
{
	echo "================================================================================="
	echo "TD_6Lo_ND_07"
	echo "Check host behavior under multiple prefixes (16-bit or other short address)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both Host and Router"
	echo "Host is configured to use 16-bit or other short address"
	echo "Router is configured with multiple prefixes"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_short
	# Setup multiple prefixes

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		echo "No stimulus needed, just watch ND address handling in wireshark"
	fi
}

test_case_29()
{
	echo "================================================================================="
	echo "TD_6Lo_ND_HC_01"
	echo "Check that EUTs make use of context 0 (EUI-64 or other long address)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both EUT1 and EUT2"
	echo "EUT1 and EUT2 are configured to use EUI-64 or other long address"
	echo "EUT1 and EUT2 are configured with a default hop limit of 64"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		# Enable receiving of context 0
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2 #What is meant with GP64 address?
		# Set hop limit to 64, no traffic class or flow label is being used
	fi
}

test_case_30()
{
	echo "================================================================================="
	echo "TD_6Lo_ND_HC_02"
	echo "Check that EUTs make use of context 0 (16-bit or other short address)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both EUT1 and EUT2"
	echo "EUT1 and EUT2 are configured to use 16-bit or other short address"
	echo "EUT1 and EUT2 are configured with a default hop limit of 64"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_short

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		# Enable receiving of context 0
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2 #What is meant with GP16 address?
		# Set hop limit to 64, no traffic class or flow label is being used
	fi
}

test_case_31()
{
	echo "================================================================================="
	echo "TD_6Lo_ND_HC_03"
	echo "Check that EUTs make use of context != 0 (EUI-64 or other long address)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both EUT1 and EUT2"
	echo "EUT1 and EUT2 are configured to use EUI-64 or other long address"
	echo "EUT1 and EUT2 are configured with a default hop limit of 64"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_eui64

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		# Enable receiving of context != 0
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2 #What is meant with GP64 address?
		# Set hop limit to 64, no traffic class or flow label is being used
	fi
}

test_case_32()
{
	echo "================================================================================="
	echo "TD_6Lo_ND_HC_04"
	echo "Check that EUTs make use of context != 0 (16-bit or other short address)"
	echo "---"
	echo "(6LoWPAN:) Header compression is enabled on both EUT1 and EUT2"
	echo "EUT1 and EUT2 are configured to use 16-bit or other short address"
	echo "EUT1 and EUT2 are configured with a default hop limit of 64"
	echo "================================================================================="

	#setup_device

	# Pre-test conditions
	enable_header_compression
	setup_address_short

	echo "EUT$EUT during this test"

	if [ $EUT == 1 ]
	then
		# Enable receiving of context != 0
		ping6 -I lowpan0 -c 1 -s 4 fe80::dcad:beef:babe:2 #What is meant with GP16 address?
		# Set hop limit to 64, no traffic class or flow label is being used
	fi
}

if [ -z "$EUT" ]
then
	echo "Node number as parameter needed"
	exit
fi

test_case_01
## Requires short-address support in linux-wpan
##test_case_02
#test_case_03
#test_case_04
## Requires short-address support in linux-wpan
##test_case_05
#test_case_06
## Requires short-address support in linux-wpan
##test_case_07
## Requires short-address support in linux-wpan
##test_case_08
### 6LoBAC only
##test_case_09
#test_case_10
## Requires short-address support in linux-wpan
##test_case_11
#test_case_12
## Requires short-address support in linux-wpan
##test_case_13
#test_case_14
## Requires short-address support in linux-wpan
##test_case_15
#test_case_16
## Requires short-address support in linux-wpan
##test_case_17
## Requires short-address support in linux-wpan
##test_case_18
## Requires short-address support in linux-wpan
##test_case_19
#test_case_20
## Requires short-address support in linux-wpan
##test_case_21
#test_case_22
## Requires short-address support in linux-wpan
##test_case_23
#test_case_24
#test_case_25
#test_case_26
#test_case_27
## Requires short-address support in linux-wpan
##test_case_28
#test_case_29
## Requires short-address support in linux-wpan
##test_case_30
#test_case_31
## Requires short-address support in linux-wpan
##test_case_32
