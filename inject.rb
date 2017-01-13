# File:   inject.rb
# Author: James Carlson -- jxxcarlson@gmail.com
# Date:   January 11, 2017
#
# PURPOSE: Return a string in which the string PAYLOAD is injected into 
# the contents of the file TARGET' right after the string AIM_POINT
#
# EXAMPLE: $ ruby inject.rb style.link.txt into index.html at "<html><head>" >index2.html
#
#          Running the above command creates a new file 'index2.html' from 'index.html'
#          where the text of 'style.link.txt' is inserted after the text '<html><head>'.
#          The content of the file 'style.link.txt' is
#
#          <link rel="stylesheet" href="http://elm-in-action.com/styles.css"><style>
#
#          In this form, the purpose of the command is to automate the process of 
#          injecting CSS into an Elm app, as described in chapter 3 of Richard Feldman's
#          book 'Elm in Action'.  This is page 103 in the current version (ibooks)
#
# SYNTAX:
#
#          ruby inject.rb PAYLOAD into TARGET at AIM_POINT

def error_message(message)
    puts
    puts "  " + message
    puts "  Please use the syntax"
    puts 
    puts "    $ ruby inject.rb PAYLOAD into TARGET at AIM_POINT"
    puts
end  

def handle_error(message)
    error_message(message)
    exit
end

handle_error("You need five arguments") if ARGV.length != 5
handle_error("The second argument is 'into'") if ARGV[1] != "into"
handle_error("The fourth argument is 'at'") if ARGV[3] != "at"

payload_name = ARGV[0]
target_name = ARGV[2]
aim_point = ARGV[4]

payload = IO.read(payload_name)
target = IO.read(target_name)

def inject(payload, target, aim_point)
    target.sub(aim_point, aim_point + payload)
end

edited_target = inject(payload, target, aim_point)
puts edited_target

