#!/bin/bash

# Make Docker build context the repository root
export repositoryRoot=../..
cd $repositoryRoot

# If it wasn't executable before... it is now
export buildUtils=./useful_functions.sh
chmod +x $buildUtils

# Check to see whether base image already exists; if it doesn't, then build it
$buildUtils if_not_base_image_then_build_it

$buildUtils smart_build                        \
    --file=nbviewer/Dockerfile                 \
    --build-arg branch=copy-to-user-server     \
    --build-arg repository=danielballan        \
    --tag nbviewer_base                        \
    .

$buildUtils smart_build                        \
    --file=nbviewer/dballanbviewer/Dockerfile  \
    --tag jupyter:dballanbviewer               \
    .

# Delete all intermediate images with label autodelete=true
$buildUtils destroy_intermediates
