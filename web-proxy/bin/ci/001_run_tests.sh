#!/bin/bash
npm install || exit 1
node_modules/expresso/bin/expresso  || exit 1
exit
