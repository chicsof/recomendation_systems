#!/usr/bin/env R
message(getwd())
pr <- plumber::plumb(commandArgs()[4])
pr$run(host="0.0.0.0", port=8000)
