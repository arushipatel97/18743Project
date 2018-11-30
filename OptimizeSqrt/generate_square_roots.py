import math

def generate():
	file = open("square_root.hex","w")
	for i in range (0,1000):
		file.write(format((int(math.ceil(math.sqrt(i)))),'x'))
		file.write("\n")

	file.close()


generate()		
