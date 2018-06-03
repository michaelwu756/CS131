#!/usr/local/cs/bin/python3

import sys

serverNames = ["Goloman", "Hands", "Holiday", "Welsh", "Wilkes"]

if len(sys.argv) < 2:
    print("Not enough arguments.")
elif sys.argv[1] not in serverNames:
    print(sys.argv[1]+" is not a valid server name. Valid names are: "+", ".join(str(x) for x in serverNames))
else:
    print("Server "+sys.argv[1])
