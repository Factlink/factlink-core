#!/bin/bash

# TODO: This is not a very safe way to stop the proxy now is it?
echo "stopping node"
killall node; true # return true to continue running, even if exit code != 0