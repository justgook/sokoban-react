#!/bin/bash
cd public
git init
git config user.name "Travis-CI"
git config user.email "travis@nodemeatspace.com"
git add .
git commit -m "Deployed to Github Pages"
git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages #> /dev/null 2>&1
