#! /usr/bin/python
import sys, time
from TOSSIM import *
from MoteMsg import *

t = Tossim([])
m = t.mac()
r = t.radio()

numberOfNodes = 3

t.addChannel("Boot", sys.stdout)
t.addChannel("Radio", sys.stdout)
t.addChannel("Serial", sys.stdout)

print "Booting nodes"
for i in range(numberOfNodes):
  m = t.getNode(i)
  m.bootAtTime((31 + t.ticksPerSecond() / 10) * i + 1)

print "Defining topology"
f = open("topo.txt", "r")
for line in f:
  s = line.split()
  if s:
    r.add(int(s[0]), int(s[1]), float(s[2]))

print "Defining noise"
noise = open("meyer-heavy.txt", "r")
for line in noise:
  s = line.strip()
  if s:
    val = int(s)
    for i in range(numberOfNodes):
      t.getNode(i).addNoiseTraceReading(val)

for i in range(numberOfNodes):
  t.getNode(i).createNoiseModel()

# run events forever
while True:
  t.runNextEvent()
  time.sleep(0.1)

# deliver a packet
msg = MoteMsg()
msg.set_version(2)
msg.set_size(2)
pkt = t.newPacket()
pkt.setData(msg.data)
pkt.setType(15)
pkt.setSource(0)
pkt.setDestination(24577)
pkt.deliver(0, t.time() + 3)
