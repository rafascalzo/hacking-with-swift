import UIKit

//Standard Swift strings use double quotes, but you can’t include line breaks in there.
//
//If you want multi-line strings you need slightly different syntax: start and end with three double quote marks, like this:

var str1 = """
This goes
over multiple
lines
"""
//Swift is very particular about how you write those quote marks: the opening and closing triple must be on their own line, but that opening and closing line breaks won’t be included in your final string.
//
//If you only want multi-line strings to format your code neatly, and you don’t want those line breaks to actually be in your string, end each line with a \, like this:

var str2 = """
This goes \
over multiple \
lines
"""
