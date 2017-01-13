# File:   inject.sh
# Author: James Carlson -- jxxcarlson@gmail.com
# Date:   January 11, 2017
#
# PURPOSE: Inject the text of the file 'style.link.txt' into the 
#          contents of the file 'index.html' right after the text
#          '<html><head>', with the output saved in the file 'index2.html'
#
#           Running this script automates the procedure described in
#           chapter 3 of Richard Feldman's book 'Elm in Action'.  
#           This is page 103 in the current version (ibooks)
#
#           The contents of style.link.txt is
#
#           <link rel="stylesheet" href="http://elm-in-action.com/styles.css"><style>

ruby inject.rb style.link.css into index.html at "<html><head>" >index2.html