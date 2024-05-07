#!/bin/bash

sudo zypper install --no-recommends cups cups-pdf ghostscript gutenprint sane simple-scan

sudo systemctl enable --now cups.service

exit 0
