import asyncio
import sys
import time

async def tcp_echo_client(message, server_name, loop):
    reader, writer = await asyncio.open_connection("127.0.0.1", 12125 + serverNames.index(name), loop = loop)

    print("Client to %s - Send: %r" % (server_name, message))
    writer.write((message).encode())
    writer.write_eof()

    data = await reader.readline()
    print("Client from %s - Received: %r" % (server_name, data.decode()))

    print("Client - Close the socket")
    writer.close()

serverNames = ["Goloman", "Hands", "Holiday", "Welsh", "Wilkes"]

if len(sys.argv) < 2:
    print("Not enough arguments.")
elif sys.argv[1] not in serverNames:
    print(sys.argv[1] + " is not a valid server name. Valid names are: " + ", ".join(str(x) for x in serverNames))
else:
    name = sys.argv[1]
    message = "IAMAT kiwi.cs.ucla.edu +34.068930-118.445127 " + str(time.time())
    loop = asyncio.get_event_loop()
    loop.run_until_complete(tcp_echo_client(message, name, loop))
    loop.close()
