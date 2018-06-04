import asyncio

async def tcp_echo_client(message, loop):
    reader, writer = await asyncio.open_connection('127.0.0.1', 12125,
                                                   loop=loop)

    print('Client - Send: %r' % message)
    writer.write(message.encode())

    data = await reader.read(100)
    print('Client - Received: %r' % data.decode())

    print('Client - Close the socket')
    writer.close()


message = 'Hello World!'
loop = asyncio.get_event_loop()
loop.run_until_complete(tcp_echo_client(message, loop))
loop.close()
