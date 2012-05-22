#!/bin/bash

export DISPLAY=:0

grunt qunit || exit 1
