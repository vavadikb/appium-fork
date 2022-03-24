#!/bin/bash

# convert to lower case using Linux/Mac compatible syntax (bash v3.2)
PLATFORM_NAME=`echo "$PLATFORM_NAME" |  tr '[:upper:]' '[:lower:]'`
if [[ "$PLATFORM_NAME" == "ios" ]]; then
  # exit for iOS devices
  exit 0
fi

if [ ! -z "$ANDROID_DEVICES" ]; then
    connected_devices=$(adb devices)
    IFS=',' read -r -a array <<< "$ANDROID_DEVICES"
    for i in "${!array[@]}"
    do
        array_device=$(echo ${array[$i]} | tr -d " ")
        #string contains check
        if [[ ${connected_devices} != *${array_device}* ]]; then
            ret=1
            while [[ $ret -eq 1 ]]; do
                echo "Connecting to: ${array_device}"
                adb connect ${array_device}
		adb devices | grep ${array_device} | grep "device"
                ret=$?
                if [[ $ret -eq 1 ]]; then
                    sleep ${REMOTE_ADB_POLLING_SEC}
                fi
            done
            echo "Connected to: ${array_device}."
        fi
    done

    if [ "$ANDROID_DEVICES" == "device:5555" ]; then
	sleep 5
	adb devices

        # switch to root account for running adb
        adb root
    fi
fi



