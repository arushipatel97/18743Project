from time import time

def sieveOfEratosthenes(total):
    sieveBool = [True for _ in range(total)]
    sieveBool[0:1] = [False, False]
    for start in range(2, total + 1):
        if sieveBool[start]:
            for i in range(2 * start, total, start):
                sieveBool[i] = False
    primesList = []
    for i in range(2, total + 1):
        if sieveBool[i]:
            primesList.append(i)
    #print(primesList)
    return primesList

if __name__=='__main__':
	 total = 100000
	 start = int(round(time() * 1000))
	 listPrimes = sieveOfEratosthenes(total)
	 end = int(round(time() * 1000))
	 print("TotalTime", end - start, "milliseconds.") 

