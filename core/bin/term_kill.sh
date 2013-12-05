#!/bin/bash
# Kills all processes attached to the current terminal.
# This is a helper to workaround https://github.com/ddollar/foreman/issues/357
pkill -t `tty |egrep -o 'pts/[0-9]+'`
