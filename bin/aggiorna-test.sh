#!/bin/bash

echo "... Removing configs /etc/nagios3"
echo
ssh root@monitor-server rm -rf /etc/nagios3/apache2.conf /etc/nagios3/commands.cfg /etc/nagios3/resource.cfg /etc/nagios3/cgi.cfg /etc/nagios3/nagios.cfg
echo "... Updating configs /etc/nagios3"
scp -p ../etc/nagios3/*.cfg ../etc/nagios3/apache2.conf root@monitor-server:/etc/nagios3

echo
echo "... Removing configs /etc/nagios3/conf.d"
echo
ssh root@monitor-server rm -rf /etc/nagios3/conf.d/*.cfg
echo "... Updating configs /etc/nagios3/conf.d"
scp -p ../etc/nagios3/conf.d/*.cfg  root@monitor-server:/etc/nagios3/conf.d


echo
echo "... Removing configs /etc/nagios-plugins/config"
echo
ssh root@monitor-server rm -rf /etc/nagios-plugins/config/*.cfg
echo "... Updating configs /etc/nagios-plugins/config"
scp -p ../etc/nagios-plugins/config/*.cfg  root@monitor-server:/etc/nagios-plugins/config

echo
echo "... Restarting Nagios ..."
echo
ssh root@monitor-server /etc/init.d/nagios3 reload


