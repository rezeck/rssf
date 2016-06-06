#! /usr/bin/python
import sys
from TOSSIM import *
from MoteMsg import *

t = Tossim([])
m = t.mac()
r = t.radio()

t.addChannel("Boot", sys.stdout)
t.addChannel("Radio", sys.stdout)

for i in range(3):
  m = t.getNode(i)
  m.bootAtTime((31 + t.ticksPerSecond() / 10) * i + 1)

f = open("topo.txt", "r")
for line in f:
  s = line.split()
  if s:
    print s;
    r.add(int(s[0]), int(s[1]), float(s[2]))

noise = open("meyer-heavy.txt", "r")
for line in noise:
  s = line.strip()
  if s:
    val = int(s)
    for i in range(3):
      t.getNode(i).addNoiseTraceReading(val)

for i in range(3):
  t.getNode(i).createNoiseModel()

for i in range(60):
  t.runNextEvent()

msg = MoteMsg()
msg.set_version(2)
msg.set_size(2)
pkt = t.newPacket()
pkt.setData(msg.data)
pkt.setType(240)
pkt.setSource(0)
pkt.setDestination(24577)

print "Delivering " + str(msg) + " to 0 at " + str(t.time() + 3);
pkt.deliver(0, t.time() + 3)

for i in range(50):
  t.runNextEvent()
