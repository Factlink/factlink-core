#!/bin/bash

export DISPLAY=:0

npm install grunt -g || exit 1

grunt qunit || exit 1
