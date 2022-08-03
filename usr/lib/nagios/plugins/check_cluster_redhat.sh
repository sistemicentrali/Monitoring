#!/bin/sh
#
# Redhat cluster service checker for Nagios
# Written by Unita21 (...)
# Last Modified: 08-06-2010
#
# Usage: ./Usage: check_cluster_redhat SERVICE | --help | -h | --version | -V
#
# Description:
#
# Redhat cluster service checker for Nagios
#
# Output:
#
# Check if cluster is active and if service is started and where.
#
# Notes: on the monitored server you need to set suid bit on /usr/sbin/clustat 
#	 i.e. # chmod u+s /usr/sbin/clustat
#	
# #
# Examples:
#
# 

ECHO="/bin/echo"
GREP="/bin/egrep"
DIFF="/bin/diff"
TAIL="/bin/tail"
CAT="/bin/cat"
RM="/bin/rm"
CHMOD="/bin/chmod"
TOUCH="/bin/touch"
CLUSTAT="/usr/sbin/clustat"
AWK="/bin/awk"

PROGNAME=`/bin/basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
REVISION=`echo '$Revision: 0001 $' | sed -e 's/[^0-9.]//g'`

#. $PROGPATH/utils.sh

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

if test -x /usr/bin/printf; then
	ECHO=/usr/bin/printf
else
	ECHO=echo
fi

print_revision() {
	echo "$1 v$2"
	$ECHO "@WARRANTY@" | sed -e 's/\n/ /g'
}

support() {
	$ECHO "@SUPPORT@" | sed -e 's/\n/ /g'
}

print_usage() {
    echo "Usage: $PROGNAME SERVICE | --help | -h | --version | -V"
}

print_help() {
    print_revision $PROGNAME $REVISION
    echo ""
    print_usage
    echo ""
    echo "Redhat cluster service checker for Nagios"
    echo ""
    support
}

# Make sure the correct number of command line
# arguments have been supplied

if [ $# -lt 1 ]; then
    print_usage
    exit $STATE_UNKNOWN
fi

# Grab the command line arguments

SERVICE=''
exitstatus=$STATE_WARNING #default
#while test -n "$1"; do
    case "$1" in
        --help)
            print_help
            exit $STATE_OK
            ;;
        -h)
            print_help
            exit $STATE_OK
            ;;
        --version)
            print_revision $PROGNAME $REVISION
            exit $STATE_OK
            ;;
        -V)
            print_revision $PROGNAME $REVISION
            exit $STATE_OK
            ;;
        *)
            SERVICE="$1"
            ;;
    esac
#    shift
#done

# The Logic

if sudo $CLUSTAT -s ${SERVICE} 1>/dev/null 2>&1 ; then
	SERVICEOWNER=`sudo $CLUSTAT -s ${SERVICE} | $GREP "${SERVICE}" | $AWK '{  print $2 }'`
	SERVICESTATUS=`sudo $CLUSTAT -s ${SERVICE} | $GREP "${SERVICE}" | $AWK '{  print $3 }'`
	RETURNSTATUS=$?

	if [ "$RETURNSTATUS" -eq "0" ]; then # OK
		if [ "$SERVICESTATUS" == "started" ] ; then
    		$ECHO "Cluster Active; Service ${SERVICE} ${SERVICESTATUS} on ${SERVICEOWNER}\n"
    		exitstatus=$STATE_OK
    	else
    		$ECHO "Cluster Active; Service ${SERVICE} ${SERVICESTATUS}\n"
    		exitstatus=$STATE_CRITICAL
    	fi
	else # NOK
    	$ECHO "ERROR or Cluster NOT Active\n"
    	exitstatus=$STATE_CRITICAL
	fi
else
	$ECHO "Service ${SERVICE} unknown\n"
    exitstatus=$STATE_UNKNOWN
fi

exit $exitstatus

