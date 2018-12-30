#!/bin/sh
git pull
chmod 755 ~/bin/*.sh
#git status
git add -A
#git status
git commit -m "scripted update"
git push
