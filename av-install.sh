
#!/bin/bash

echo "Starting AV Installation Script ..."

#### Extract AV package ####
echo "Extracting Package"
cd /tmp/ || { echo "Failed to change to /tmp/" ; exit 1; }
tar -xvf AV_trendmicro_latest.tar
echo "Extraction done"

#### Install RPM package ####

if [[ $(uname -r | grep '^5\.14') wc -l) -eq 1 ]]; then
    AV_PACKAGE="Agent-Core-RedHat_EL9.20.0-2.9811.x86_64.rpm"

elif [[ $(uname -r | grep '^4\.18') wc -l) -eq 1 ]]; then
    AV_PACKAGE="Agent-Core-RedHat_EL8.20.0-2.9811.x86_64.rpm"

elif [[ $(uname -r | grep '^3\.10') wc -l) -eq 1 ]]; then
    AV_PACKAGE="Agent-Core-RedHat_EL7.20.0-2.9811.x86_64.rpm"

else
    echo "Could not determine the OS version" exit 1
fi

echo "Detected RHEL VERSION $OS_VERSION installing $AV_PACKAGE ..."

cd /tmp/AV_trendmicro_latest;
rpm -ivh $AV_PACKAGE
echo "Installation Complete"

echo "Starting the enrollment of the .der keys"

cp /tmp/AV_trendmicro_latest/DS20_v2.der /opt/ds_agent
cp /tmp/AV_trendmicro_latest/DS2022.der /opt/ds_agent
echo "Copy operation done."

echo -e "123456\n123456" | mokutil --import /opt/ds_agent/DS2022.der /opt/ds_agent/DS20_v2.der

###  FINAL MESSAGE  ### 
echo "AV installation successfully completed"
echo "reboot the system for Secure Boot changes to take effect if the server is RHEL8 or Later"
