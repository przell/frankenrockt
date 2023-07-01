#!/usr/bin/env bash

gunicorn -w 1 -b 127.0.0.1:5000 api:app
