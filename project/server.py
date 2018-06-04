#!/usr/local/cs/bin/python3

import asyncio
import sys
import socket
import logging
import time
import re
import urllib.request
import json

def get_coordinates(s):
    match = re.search(r"(?P<latitude>[+-][0-9]{2}(\.[0-9]+)?)(?P<longitude>[+-][0-9]{3}(\.[0-9]+)?)", s)
    return (match.group("latitude"), match.group("longitude"))

def validate_coordinates(s):
    match = re.search(r"(?P<latitude>[+-][0-9]{2}(\.[0-9]+)?)(?P<longitude>[+-][0-9]{3}(\.[0-9]+)?)", s)
    if (match and
        float(match.group("latitude")) <= 90 and
        float(match.group("latitude")) >= -90 and
        float(match.group("longitude")) <= 180 and
        float(match.group("longitude")) >= -180):
        return True
    return False

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
        if len(splitted) == 4 and splitted[0] == "IAMAT" and validate_coordinates(splitted[2]):
            timeDiff = time.time() - float(splitted[3])
            prefix = ""
            if timeDiff > 0:
                prefix = "+"
            await propagate("", name, prefix + str(timeDiff), *splitted[1:])
            return "AT " + name + " " + prefix + str(timeDiff) + " " + splitted[1] + " " + splitted[2] + " " + splitted[3]
        elif len(splitted) == 7 and splitted[0] == "PROPAGATE":
            await propagate(*splitted[1:])
            return ""
        elif (len(splitted) == 4 and
              splitted[0] == "WHATSAT" and
              splitted[1] in clients and
              float(splitted[2])<=50 and
              float(splitted[2])>0 and
              int(splitted[3])<=20 and
              int(splitted[3])>0):
            url = ("https://maps.googleapis.com/maps/api/place/nearbysearch/json"
                   "?key=AIzaSyC679zLA94MgQ9xF0NiyxqYA4lt4HIDInM"
                   "&location={},{}&radius={}").format(*get_coordinates(clients[splitted[1]][2]), float(splitted[2])*1000)
            response = json.load(urllib.request.urlopen(url))
            response["results"] = response["results"][:int(splitted[3])]
            return ("AT " + clients[splitted[1]][0] + " "
                    + clients[splitted[1]][1] + " "
                    + splitted[1] + " "
                    + clients[splitted[1]][2] + " "
                    + str(clients[splitted[1]][3]) + "\n"
                    + json.dumps(response, indent=3, separators=(',', ' : ')))
    except Exception as ex:
        logging.exception("Failed Parsing Input")
    return "? " + s.strip()

async def on_input(reader, writer):
    while not reader.at_eof():
        data = await reader.readline()
        message = data.decode()
        addr = writer.get_extra_info("peername")
        await print_and_log("%s - Received %r from %r" % (name, message, addr))

        returnMessage = await process_string(message) + "\n\n"
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

    coroutine = asyncio.start_server(on_input, "0.0.0.0", port, loop = loop)
    server = loop.run_until_complete(coroutine)

    # Serve requests until Ctrl+C is pressed
    print("Serving on {}".format(server.sockets[0].getsockname()))
    try:
        loop.run_forever()
    except KeyboardInterrupt:
        pass

    # Close the server
    server.close()
    loop.run_until_complete(server.wait_closed())
    loop.close()
