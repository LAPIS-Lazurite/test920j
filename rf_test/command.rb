#! /usr/bin/ruby

require './openif.rb'

while 1
	print("input command[exit:Enter]: ")
	com = gets().to_s
	if com.eql?("\n") == true then
		break
	else
		$sp.puts(com)
		p $sp.gets()
	end
end

$sock.close
$sp.close
