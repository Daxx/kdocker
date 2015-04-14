#!/bin/sh

# Example - not in use
qdbusxml2cpp  com.kdocker.xml  -a dbus_adaptor  -c KDockerDBus  -l TrayItemManager  -N
qdbusxml2cpp  com.kdocker.xml  -p dbus_proxy    -c KDockerDBus  -l TrayItemManager  -N
