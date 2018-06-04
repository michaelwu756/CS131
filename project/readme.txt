This project implements a server herd. Each server communicates with each other
and propagates location information with each other using a flooding
algorithm. They can be used to query what is around a client using the google
places API> Currently five servers named Goloman, Hands, Holiday, Welsh, and
Wilkes can be started. Start a server by doing:

make <server_name>

Additionally, you can start all servers by doing:

make startServers

This is also the default target, so you can also just do:

make

To stop all servers, do:

make stopServers

The servers establish tcp connections over the ports 12125-12129 and take in
commands of the format:

IAMAT <id> <coordinates> <timestamp>
WHATSAT <id> <radius> <max_results>

Here <id> is the name a client, <coordinates> is a latitude and longitude
specification in decimal ISO6709 format, <timestamp> is a float representing
seconds from UNIX epoch, <radius> is a radius in kilometers to search around the
client with <id>, and <max_results> is the maximum number of results to return
in our search.

As a response to these commands, the server will send information back to the
client in the following format for an IAMAT command:

AT <server_name> <time_difference> <id> <coordinates> <timestamp>

The field <time_difference> is the time at which the origin server recieved the
IAMAT command minus the time given in the timestamp.

Each server starts with no knowledge of any clients. If a client connects to one
of the servers and gives an IAMAT command, it will propagate to all the
connected servers in the herd. To support this, there is a PROPAGATE command
with the following syntax:

PROPAGATE <sending_server> <origin_server> <time_difference> <id> <coordinates> <timestamp>

Here the new field <sending_server> represents the name of the server sending
the PROPAGATE command, <origin_server> represents the name of the server which
recieve the original IAMAT command. The recieving server propagates to every
server that it is connected to except the sending server.

As a response to the WHATSAT command, the server will send the client the
following:

AT <origin_server> <time_difference> <id> <coordinates> <timestamp>
<json_response>

The field <json_response> is the response of querying the google places API server.

The servers will generate a log at <server_name>.log that records its inputs and
outputs. To clean up these logs, do:

make clean


I have written a client program to facilitate easy communication with the
servers. The client assumes the servers are hosted on the localhost, but the
host address can be modified in the source of client.py. To start the client for
a given server, run the command:

make ping<server_name>

The client can take commands from stdin in the following format:

IAMAT <id> <coordinates>
WHATSAT <id> <radius> <max_results>

These fields mean the same as before, but the client will automatically
generate a timestamp for the IAMAT command. The client then sends the command to
the appropriate server and relays the response.
