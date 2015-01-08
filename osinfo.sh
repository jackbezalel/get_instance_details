#!/bin/sh

# Author: Jack Bezalel

#Functions

# General notes
#
# The following situations NOT considered an error, thus 
# we exit with $TRUE (all OK) in those cases:
# 1. Not supporting an operating system 
# 2. No patch for this operating system
#

FALSE=1
TRUE=0

OSINFO_ROOT="/patches/machines/OSINFO"

. ./services.sh
. ./get_linux_vendor.sh
. ./get_os_major_vers.sh

#Main

HOSTNAME="`hostname`"
OSNAME="`uname -s`"
OSINFO_DATE="`date +"%Y%m%d%H%M"`"

case $OSNAME in
Linux)
	LINUX_VENDOR="`GET_LINUX_VENDOR`"
	if 	[ $LINUX_VENDOR = "error" ];
	then
        	echo "We do not support OSINFO for $OSNAME yet.."
        	exit $TRUE
	fi
	
	echo "Vendor=$LINUX_VENDOR"

	OS_MAJOR_VERS="`GET_OS_MAJOR_VERS $LINUX_VENDOR`"

	if 	[ $OS_MAJOR_VERS = "error" ];
	then
        	echo "We do not support OSINFO for $LINUX_VENDOR yet.."
        	exit $TRUE
	fi
	
	echo "Major Version=$OS_MAJOR_VERS"
	OSARCH="`uname -i`"
	MACHINE_OSINFO_DIR="$OSINFO_ROOT/$HOSTNAME/$OSINFO_DATE"
	echo "Machine $HOSTNAME OSINFO will be reported at $MACHINE_OSINFO_DIR"

	if [ $LINUX_VENDOR = "redhat" ];
	then
		mkdir -p $MACHINE_OSINFO_DIR
		echo "OSINFO dump `date`" > $MACHINE_OSINFO_DIR/osinfo.log
		echo "HARDWARE: `dmidecode -s system-manufacturer`" \
			>> $MACHINE_OSINFO_DIR/osinfo.log
		echo "CPU: `cat /proc/cpuinfo | grep processor | wc -l`" \
               		>> $MACHINE_OSINFO_DIR/osinfo.log
        	echo "MEM: `cat /proc/meminfo | grep -i memtotal`" \
                	>> $MACHINE_OSINFO_DIR/osinfo.log
        	parted -l | grep "Disk /dev" | grep -v "mapper" | \
                while read i; do   echo -e "DISK: $i" ; done \
                	        >> $MACHINE_OSINFO_DIR/osinfo.log
		lspci | grep -i 'Ethernet controller' | \
		while read i; do
        		echo "NET: $i" ;
		done \
                       	>> $MACHINE_OSINFO_DIR/osinfo.log
        	cat $MACHINE_OSINFO_DIR/osinfo.log
	else
		echo "We do not support OSINFO for $LINUX_VENDOR yet.."
		exit $TRUE
	fi
;;

SunOS)
	OS_MAJOR_VERS="`GET_OS_MAJOR_VERS $OSNAME`"

	if 	[ $OS_MAJOR_VERS = "error" ];
	then
        	echo "We do not support OSINFO for $OSNAME yet.."
        	exit $TRUE
	fi

	echo "Vendor=$OSNAME"	
	echo "Major Version=$OS_MAJOR_VERS"
	
	# Check if this machine has zones software installed
	# Then if that's a sparse zone it should be handled by
	# updating the global zone rather than directly

	if	[ -f /usr/bin/zonename ];
	then
		ZONE_NAME="`zonename`"
		echo "ZONE $ZONE_NAME"
		ZONE_TYPE="`pkgcond -n is_what | grep 'is_global_zone=0'`"
		if	[ " $ZONE_TYPE" != " " ];
		then	
			echo "Execution aborted since this NOT a global zone."
			echo "Please re-run on the global zone."
			exit $TRUE
		fi
	fi


	OSARCH="`uname -m`"

        MACHINE_OSINFO_DIR="$OSINFO_ROOT/$HOSTNAME/$OSINFO_DATE"
        echo "Machine $HOSTNAME OSINFO will be reported at $MACHINE_OSINFO_DIR"

        mkdir -p $MACHINE_OSINFO_DIR
	HARDWARE_TYPE="`uname -i`" 
	if	[ " `prtconf | grep -i 'virtual-devices'`" != " " ];
	then
		HARDWARE_TYPE="VIRTUAL $HARDWARE_TYPE"
	fi
	echo "OSINFO dump `date`" > $MACHINE_OSINFO_DIR/osinfo.log
	echo "HARDWARE: $HARDWARE_TYPE" >> $MACHINE_OSINFO_DIR/osinfo.log
	echo "CPU: `psrinfo | wc -l`" \
              >> $MACHINE_OSINFO_DIR/osinfo.log
        echo "MEM: `prtconf | grep -i 'Memory size'`" \
              >> $MACHINE_OSINFO_DIR/osinfo.log

	i=" "
	echo "0 q" | format 2>/dev/null | \
	until [ "`(echo $i | cut -c0-12)`" = "Specify disk" ]
	do
       		read i
       		DISK_LINE=" `echo $i | grep '^[0-9].'`"
		if 	[ "$DISK_LINE" != " " ];
		then	
			echo "DISK:" $DISK_LINE
		fi
	done \
               	>> $MACHINE_OSINFO_DIR/osinfo.log
	echo "NET: `prtconf|grep -i 'network, instance' | wc -l`" \
                >> $MACHINE_OSINFO_DIR/osinfo.log
        cat $MACHINE_OSINFO_DIR/osinfo.log
;;

HP-UX)
	OS_MAJOR_VERS="`GET_OS_MAJOR_VERS $OSNAME`"

	if 	[ $OS_MAJOR_VERS = "error" ];
	then
        	echo "We do not support OSINFO for $OSNAME yet.."
        	exit $TRUE
	fi

	echo "Vendor=$OSNAME"	
	echo "Major Version=$OS_MAJOR_VERS"
	
	OSARCH="`uname -m`"

        MACHINE_OSINFO_DIR="$OSINFO_ROOT/$HOSTNAME/$OSINFO_DATE"
        echo "Machine $HOSTNAME OSINFO will be reported at $MACHINE_OSINFO_DIR"

        mkdir -p $MACHINE_OSINFO_DIR
	HARDWARE_TYPE="`model`" 
	echo "OSINFO dump `date`" > $MACHINE_OSINFO_DIR/osinfo.log
	echo "HARDWARE: $HARDWARE_TYPE" >> $MACHINE_OSINFO_DIR/osinfo.log
	echo "CPU: `ioscan -C processor -l -F | wc -l`" \
              >> $MACHINE_OSINFO_DIR/osinfo.log
        echo "MEM: `print_manifest |grep -i memory`" \
              >> $MACHINE_OSINFO_DIR/osinfo.log
        echo "`ioscan -fC disk`" | while read i; do   
		if 	[ "`echo $i | cut -c0-4`" = "disk" ];
		then
			echo "DISK: $i"
		fi
	done \
               	>> $MACHINE_OSINFO_DIR/osinfo.log
        lanscan | grep "lan" | grep -v "DOWN" | \
        while read i; do
              echo "NET: $i" ;
        done \
              >> $MACHINE_OSINFO_DIR/osinfo.log

		>> $MACHINE_OSINFO_DIR/osinfo.log

        cat $MACHINE_OSINFO_DIR/osinfo.log
;;

*)
	echo "We do not support OSINFO for $OSNAME yet.."
	exit $TRUE
;;

esac

