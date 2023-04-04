#!/bin/bash
set -x
#credits to https://github.com/Louisvdw/dbus-serialbattery


DRIVERNAME=dbus-aggregate-batteries

#handle read only mounts
sh /opt/victronenergy/swupdate-scripts/remount-rw.sh

#install
rm -rf /opt/victronenergy/service/$DRIVERNAME
rm -rf /opt/victronenergy/$DRIVERNAME
mkdir /opt/victronenergy/$DRIVERNAME
ln -s /data/$DRIVERNAME/service /opt/victronenergy/service/$DRIVERNAME 

#restart if running
pkill -f "python .*/$DRIVERNAME.py"

# add install-script to rc.local to be ready for firmware update
filename=/data/rc.local
if [ ! -f $filename ]; then
    echo "#!/bin/bash" >> $filename
    chmod 755 $filename
fi
grep -qxF "sh /data/$DRIVERNAME/install.sh" $filename || echo "sh /data/$DRIVERNAME/install.sh" >> $filename


# also set link directly to get it started by svscan at install time
ln -s /data/$DRIVERNAME/service /service/$DRIVERNAME
