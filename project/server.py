#!/usr/local/cs/bin/python3

import asyncio
import sys
import socket

async def process_string(s):
    splitted = s.split()
    try:
        if len(splitted)==4 and splitted[0]=="IAMAT":
            timeDiff = time.time()-int(splitted[3])
            prefix = ""
            if timediff>0:
                prefix = "+"
            return "AT "+name+" "+prefix+str(timeDiff)+" "+splitted[1]+" "+splitted[2]+" "+splitted[3]
        elif len(splitted)==4 and splitted[0]=="WHATSAT":
            return "RECIEVED WHATSAT"
    except:
        pass
    return "? "+s

async def on_input(reader, writer):
    data = await reader.read(100)
    message = data.decode()
    addr = writer.get_extra_info('peername')
    print("%s - Received %r from %r" % (name, message, addr))

    returnMessage = await process_string(message)
    print("%s - Send: %r" % (name,returnMessage))
    writer.write(str.encode(returnMessage))
    await writer.drain()

    #print("%s - Close the client socket" % name)
    #writer.close()

serverNames = ["Goloman", "Hands", "Holiday", "Welsh", "Wilkes"]

if len(sys.argv) < 2:
    print("Not enough arguments.")
elif sys.argv[1] not in serverNames:
    print(sys.argv[1]+" is not a valid server name. Valid names are: "+", ".join(str(x) for x in serverNames))
else:
    print("Server "+sys.argv[1])
    name = sys.argv[1]
    port = 12125+serverNames.index(name)
    if name=="Goloman":
        talksWith = ["Hands", "Holiday", "Wilkes"]
    elif name=="Hands":
        talksWith = ["Goloman",  "Wilkes"]
    elif name=="Holiday":
        talksWith = ["Goloman", "Welsh", "Wilkes"]
    elif name=="Welsh":
        talksWith = ["Holiday"]
    elif name=="Wilkes":
        talksWith = ["Goloman", "Hands", "Holiday"]

    loop = asyncio.get_event_loop()

    coroutine = asyncio.start_server(on_input, '0.0.0.0', port, loop=loop)
    server = loop.run_until_complete(coroutine)

    # Serve requests until Ctrl+C is pressed
    print('Serving on {}'.format(server.sockets[0].getsockname()))
    try:
        loop.run_forever()
    except KeyboardInterrupt:
        pass

    # Close the server
    server.close()
    loop.run_until_complete(server.wait_closed())
    loop.close()
