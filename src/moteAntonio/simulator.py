#! /usr/bin/python
import sys, time
from TOSSIM import *
from MoteMsg import *

numberOfNodes = 3
tcpPort = 9001

t = Tossim([])
m = t.mac()
r = t.radio()
sf = SerialForwarder(tcpPort)
throttle = Throttle(t, 10)

t.addChannel("Boot", sys.stdout)
t.addChannel("Radio", sys.stdout)
t.addChannel("Serial", sys.stdout)

print "Booting nodes"
for i in range(numberOfNodes):
  m = t.getNode(i)
  m.bootAtTime((31 + t.ticksPerSecond() / 10) * i + 1)

print "Starting Serial"
sf.process()
throttle.initialize()

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
  throttle.checkThrottle()
  t.runNextEvent()
  sf.process()
  time.sleep(0.1)

# deliver a packet
#msg = MoteMsg()
#msg.set_version(2)
#msg.set_size(2)
#pkt = t.newPacket()
#pkt.setData(msg.data)
#pkt.setType(240)
#pkt.setDestination(65535)
#pkt.deliver(0, t.time() + 10)
