import asyncio
import sys
import time

async def tcp_echo_client(server_name, loop):
    reader, writer = await asyncio.open_connection("127.0.0.1", 12125 + serverNames.index(name), loop = loop)

    print(">", end = "", flush = True)
    for line in sys.stdin:
        message = line
        try:
            if line.split()[0] == "IAMAT":
                message = message.strip() + " " + str(time.time()) + "\n"
        except:
            pass

        print("Client to %s - Send: %r" % (server_name, message))
        writer.write((message).encode())

        data = await reader.readuntil(separator = b"\n\n")
        print("Client from %s - Received:" % server_name)
        print(data.decode())
        print(">", end = "", flush = True)

    print("Client - Close the socket")
    writer.close()

serverNames = ["Goloman", "Hands", "Holiday", "Welsh", "Wilkes"]

if len(sys.argv) < 2:
    print("Not enough arguments.")
elif sys.argv[1] not in serverNames:
    print(sys.argv[1] + " is not a valid server name. Valid names are: " + ", ".join(str(x) for x in serverNames))
else:
    name = sys.argv[1]
    loop = asyncio.get_event_loop()
    try:
        loop.run_until_complete(tcp_echo_client(name, loop))
    except KeyboardInterrupt:
        pass
    loop.close()
