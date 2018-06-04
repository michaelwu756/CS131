#!/usr/local/cs/bin/python3

import asyncio
import sys
import socket
import logging
import time

async def print_and_log(s):
    print(s)
    logFile = open(name + ".log", "a+")
    print(s, file = logFile)
    logFile.close()

async def send_message(message, other_name, loop):
    reader, writer = await asyncio.open_connection("127.0.0.1", 12125 + serverNames.index(other_name), loop = loop)

    await print_and_log("%s to %s - Send: %r" % (name, other_name, message))
    writer.write(message.encode())

    await print_and_log("%s to %s - Close the socket" % (name, other_name))
    writer.close()

async def process_string(s):
    splitted = s.split()
    try:
        if len(splitted) == 4 and splitted[0] == "IAMAT":
            timeDiff = time.time() - float(splitted[3])
            prefix = ""
            if timeDiff > 0:
                prefix = "+"
            await propagate("", name, prefix + str(timeDiff), *splitted[1:])
            return "AT " + name + " " + prefix + str(timeDiff) + " " + splitted[1] + " " + splitted[2] + " " + splitted[3]
        elif len(splitted) == 7 and splitted[0] == "PROPAGATE":
            await propagate(*splitted[1:])
            return ""
        elif len(splitted) == 4 and splitted[0] == "WHATSAT":
            return "RECIEVED WHATSAT"
    except Exception as ex:
        logging.exception("Failed Parsing Input")
    return "? " + s

async def on_input(reader, writer):
    while not reader.at_eof():
        data = await reader.readline()
        message = data.decode()
        addr = writer.get_extra_info("peername")
        await print_and_log("%s - Received %r from %r" % (name, message, addr))

        returnMessage = await process_string(message)
        if returnMessage != "":
            await print_and_log("%s - Send: %r" % (name, returnMessage))
            writer.write(returnMessage.encode())
            await writer.drain()

    await print_and_log("%s - Close the client socket" % name)
    writer.close()

async def propagate(from_server, origin, timeDiff, n, loc, t):
    if n not in clients or float(t) > clients[n][3]:
        clients[n] = (origin, timeDiff, loc, float(t))
        for other in talksWith:
            try:
                if other != from_server:
                    await send_message("PROPAGATE "+name+" "+origin+" "+timeDiff+" "+n+" "+loc+" "+t, other, loop = loop)
            except ConnectionRefusedError:
                await print_and_log("%s - Could not connect to %s" % (name, other))
    else:
        await print_and_log("%s - Old information: %s %s %s %s %s" % (name, origin, timeDiff, n, loc, t))

serverNames = ["Goloman", "Hands", "Holiday", "Welsh", "Wilkes"]

if len(sys.argv) < 2:
    print("Not enough arguments.")
elif sys.argv[1] not in serverNames:
    print(sys.argv[1] + " is not a valid server name. Valid names are: " + ", ".join(str(x) for x in serverNames))
else:
    print("Server " + sys.argv[1])
    name = sys.argv[1]
    port = 12125 + serverNames.index(name)
    clients = {}
    if name == "Goloman":
        talksWith = ["Hands", "Holiday", "Wilkes"]
    elif name == "Hands":
        talksWith = ["Goloman", "Wilkes"]
    elif name == "Holiday":
        talksWith = ["Goloman", "Welsh", "Wilkes"]
    elif name == "Welsh":
        talksWith = ["Holiday"]
    elif name == "Wilkes":
        talksWith = ["Goloman", "Hands", "Holiday"]

    loop = asyncio.get_event_loop()

    coroutine = asyncio.start_server(on_input, '0.0.0.0', port, loop = loop)
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
