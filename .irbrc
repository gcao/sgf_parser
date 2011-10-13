puts "Loading #{__FILE__}"
$:.push(File.dirname(__FILE__) + '/lib')

require 'sgf'
include SGF

require 'pp'
require 'awesome_print'
