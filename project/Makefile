PROG = python3 server.py
CLIENT = python3 client.py

Goloman Hands Holiday Welsh Wilkes: server.py
	$(PROG) $@ &

pingGoloman pingHands pingHoliday pingWelsh pingWilkes: client.py
	$(CLIENT) $(@:ping%=%)

stopServers:
	killall python3

.PHONY: Goloman Hands Holiday Welsh Wilkes pingGoloman pingHands pingHoliday pingWelsh pingWilkes stopServers
