#!/bin/bash
bundle install
bundle exec ruby server.rb -p 4567 -e development
