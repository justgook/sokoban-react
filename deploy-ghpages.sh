#!/bin/bash
rm -rf public || exit 0;
mkdir public;
npm run-script deploy
( cd public
 git init
 git config user.name "Travis-CI"
 git config user.email "travis@nodemeatspace.com"
 # cp ../CNAME ./CNAME
 # cp ../countryiso.js ./countryiso.js
 git add .
 git commit -m "Deployed to Github Pages"
 git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages #> /dev/null 2>&1
)