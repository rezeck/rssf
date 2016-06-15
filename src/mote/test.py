#!/usr/bin/python
import sys, time
from TOSSIM import *
from MoteMsg import *

t = Tossim([])
m = t.mac()
r = t.radio()
sf = SerialForwarder(9001)
throttle = Throttle(t, 10)

t.addChannel("Boot", sys.stdout)
t.addChannel("Radio", sys.stdout)
t.addChannel("Serial", sys.stdout)

for i in range(3):
  m = t.getNode(i)
  m.bootAtTime((31 + t.ticksPerSecond() / 10) * i + 1)

sf.process()
throttle.initialize()

for i in range(60):
  throttle.checkThrottle()
  t.runNextEvent()
  sf.process()

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
pkt = t.newSerialPacket()
pkt.setData(msg.data)
pkt.setType(240)
#pkt.setSource(0)
pkt.setDestination(65535)

print "Delivering " + str(msg) + " to 0 at " + str(t.time() + 10);
pkt.deliver(0, t.time() + 10)

for i in range(60):
  throttle.checkThrottle()
  t.runNextEvent()
  sf.process()
