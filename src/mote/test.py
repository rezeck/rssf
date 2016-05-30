#!/usr/bin/env python

from TOSSIM import *
import sys

t = Tossim([])
r = t.radio()
t.addChannel("Mote", sys.stdout);

r.add(1, 2, -54.0)
r.add(2, 1, -55.0)
r.add(2, 3, -64.0)
r.add(3, 2, -64.0)

noise = open("meyer.txt", "r")
for line in noise:
	str1 = line.strip()
	if str1:
		val = int(str1)
		t.getNode(1).addNoiseTraceReading(val)
		t.getNode(2).addNoiseTraceReading(val)
		t.getNode(3).addNoiseTraceReading(val)

for i in range(1, 4):
  print "Creating noise model for ", i
  t.getNode(i).createNoiseModel()

t.getNode(1).bootAtTime(100);
t.getNode(2).bootAtTime(100);
t.getNode(3).bootAtTime(100);
#t.getNode(1).bootAtTime(100001);
#t.getNode(2).bootAtTime(800008);
#t.getNode(3).bootAtTime(1800009);

for i in range(2000):
	#input("Press Enter to continue...")
	v = t.runNextEvent()
	if v != True and v != False:
		print v