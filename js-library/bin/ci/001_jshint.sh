#!/bin/bash
npm install grunt -g || exit 1
grunt lint || exit 1
exit
