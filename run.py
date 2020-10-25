import os
import sys
from datetime import datetime
import time
import random, string

# def test():
    # os.system("make")
    # print(" Benchmarking ")
    # start = time.time()
    # os.system("./brainfuck hello.b")
    # return time.time() - start

if sys.argv[1] == "encrypt":
    print("ENCRYPTING NEW BARCODE \n\n\n")
    time.sleep(.4)
    os.system("gcc -no-pie -o hide hide.s && ./hide && echo '\n' && xxd -b barcode.bmp") 
    os.system(" gcc -no-pie -o hide hide.s && ./hide && echo '\n' && xxd -b barcode.bmp") 

elif sys.argv[1] == "decrypt":
    print("DECRYPTING BARCODE\n\n\n")
    time.sleep(.4)
    os.system("gcc -no-pie -o unhide unhide.s && ./unhide") 

elif sys.argv[1] == "key":
    print("GENERATING NEW KEY\n\n\n")
    print("".join(random.choice("WBR") for _ in range(32)) + "E")

else:
    print("Please specialise encrypt or decrypt instruction")


