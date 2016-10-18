#! /usr/bin/ruby

require './subghz.rb'

while 1
	print("input command[exit:Enter]: ")
	s = gets().to_s
	if s.eql?("\n") == true then
		break
	else
		sbg = Subghz.new()
		p sbg.com(s)
	end
end
