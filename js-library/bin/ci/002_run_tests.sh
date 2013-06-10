#!/bin/bash

export DISPLAY=:0

grunt coffee || exit 1
grunt qunit --no-color || exit 1
