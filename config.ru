# This file is used by Rack-based servers to start the application.
require ::File.expand_path('../lib/bitr',  __FILE__)
require 'pry'

# The project root directory
root = ::File.dirname(__FILE__)

@@urls = {}
run BitR::Server.new
