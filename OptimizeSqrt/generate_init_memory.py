def init_memory(size,file):
	file = open(file,"w")
	for i in range(0,size):
		file.write("0\n")
	file.close()


init_memory(168,"prime_ram.hex")
init_memory(1000,"bool_ram.hex")
	
