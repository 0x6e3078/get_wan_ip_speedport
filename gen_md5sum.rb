#!/usr/bin/env ruby
require 'digest/md5'
puts "Enter password: "
pw=gets.chomp
digest = Digest::MD5.hexdigest(pw)
puts digest
