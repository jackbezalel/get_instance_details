#!/bin/sh

GET_OS_MAJOR_VERS()
{

OS_VENDOR=$1

case $OS_VENDOR in
redhat)
        OS_MAJOR_VERS="`cat /etc/redhat-release | head -1 | \
		awk '{ print $7 }' | awk -F. '{ print $1 }'`"
        echo $OS_MAJOR_VERS
        return $TRUE
;;

SunOS)
        OS_MAJOR_VERS="`uname -r`"
        echo $OS_MAJOR_VERS
        return $TRUE
;;

*)
	echo "error"
        exit $TRUE
;;

esac


return $FALSE

}
