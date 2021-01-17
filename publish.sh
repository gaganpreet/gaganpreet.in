#!/bin/bash
rm -rf public
hugo
rsync -aP public/ vps:/home/gagan/website-vps/gaganpreet-in/public
