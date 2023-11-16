#!/bin/bash
apk add git
git clone -b master https://github.com/TechnologyOfInformatics/Sisviansa.git
mv Sisviansa/Main.sh Main.sh
find /Sisviansa -type f -print0 | xargs -0 dos2unix --
