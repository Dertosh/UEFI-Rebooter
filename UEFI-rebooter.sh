#!/bin/bash
# Setup default cofinuration values 
# first parameter - lable of record
#
# --setfirst - set first in boot order
#
# --bootnext - set BootNext

if [ "$#" -lt "1" ]; then
echo "$0: few arguments"
return
fi

#$1 - lable of boot record
LABLE=$1 #"Windows Boot Manager"

# Get LABLE boot number.
NUMBER=$(efibootmgr | sed "/Boot[0-9].*$LABLE/!d;s/Boot//;s/\*.*//")

#check select number
if [ -z "$NUMBER" ]; then
echo "$0: $LABLE - no such lable in boot list."
return
fi

#set first in boot order
set_first()
{
    # Make new boot order with LABLE in top.
    OPT=$NUMBER,$(efibootmgr | sed "/BootOrder:/!d;s/BootOrder: //;s/\*.*//;s/.$NUMBER//")

    # Add new boot options.
    efibootmgr -o  --bootorder $OPT
}

#will be reboot at once  
bootnext()
{
    efibootmgr --bootnext $NUMBER
}

if [ "$2" = "--bootnext" ]; then
    bootnext
else
    set_first
fi

#reboot system
reboot


