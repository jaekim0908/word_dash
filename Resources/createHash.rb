#!/usr/bin/ruby 

file = File.new("SAT.txt", "r")
while(line = file.gets)
	myArray = line.split
	word = myArray[0]
	definition = myArray[2]
	for i in 3 .. myArray.length-1 do
		definition.concat(" ").concat(myArray[i])	
	end
	puts "[dictionary setObject:[NSString stringWithString:@\"#{definition}\"] forKey:@\"#{word}\"];"
end
file.close
