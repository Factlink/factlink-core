#!/bin/bash
docker run -d \
  -v ~/dev/factlink/ruby-web-proxy:/webproxy \
  -p 4567:4567 \
  -w /webproxy \
  d11wtq/ruby \
  ./run.sh

