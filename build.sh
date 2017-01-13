# My build script for Elm projects
# Exmaples:
#
#   $ sh build.sh main.elm
#
#   $ sh build.sh ladidah.elm
#
# All this compile the source file to
#
#   index.html -- no css
#   index2.html -- css is injected
#

echo
echo "compiling $1 to index.html"
elm-make $1 --output index.html

echo "injecting css ... writing index2.html"
sh inject.sh
echo
