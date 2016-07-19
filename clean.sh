#!/bin/bash

if [ -f *.lst ]
    then rm *.lst
fi

if [ -f *.obj ]
    then rm *.obj
fi

if [ -f *.sym ]
    then rm *.sym
fi

if [ -f *.usage ]
    then rm *.usage
fi

if [ -f data/tbl_mode7_scaling.bin ]
    then rm data/tbl_mode7_scaling.bin
fi

if [ -f Valid.ext ]
    then rm -f Valid.ext
fi
