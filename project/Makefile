PROG = python3 server.py
CLIENT = python3 client.py

startServers: Goloman Hands Holiday Welsh Wilkes

stopServers:
	killall python3

Goloman Hands Holiday Welsh Wilkes: server.py
	$(PROG) $@ &

pingGoloman pingHands pingHoliday pingWelsh pingWilkes: client.py
	$(CLIENT) $(@:ping%=%)

clean:
	rm -rf *.log

project.tgz: server.py client.py Makefile readme.txt
	tar -czf $@ $^

.PHONY: Goloman Hands Holiday Welsh Wilkes pingGoloman pingHands pingHoliday pingWelsh pingWilkes startServers stopServers clean
