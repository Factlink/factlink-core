#!/bin/bash
export DISPLAY=:0
grunt qunit --no-color || exit 1
exit
