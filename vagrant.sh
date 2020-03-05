#!/bin/bash

if [ $1="up" ];then
    vagrant reload db 
    vagrant reload webapp 
    vagrant reload bench 
elif [ $1="halt" ];then
    vagrant halt webapp 
    vagrant halt db 
    vagrant halt bench 
fi
