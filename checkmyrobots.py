#!/usr/bin/env python

'''
	CheckMyRobots
		  SbD

	      a0rtega
'''

import httplib
import sys

if (len(sys.argv) != 2):
	print "CheckMyRobots help"
	print "%s website" % (sys.argv[0])
	print "%s www.securitybydefault.com" % (sys.argv[0])
	sys.exit()

try:
	conn = httplib.HTTPConnection(sys.argv[1])
	conn.request("GET", "/robots.txt")
	r1 = conn.getresponse()
	if (r1.status == 200):
		sys.stderr.write("robots.txt fetched, parsing ...\n")
		robots = r1.read()
		for line in robots.split("\n"):
			if (line.find("Disallow") != -1):
				try:
					directory = line.split(": ")[1].rstrip()
					if (directory != ""):
						conn2 = httplib.HTTPConnection(sys.argv[1])
						conn2.request("GET", directory)
						r2 = conn2.getresponse()
						print "%s [%s - %s]" % (directory, r2.status, r2.reason)
						conn2.close()
				except:
					pass
	else:
		print "Unable to get robots.txt from %s [%s - %s]" % (sys.argv[1], r1.status, r1.reason)
	conn.close()
except:
	print "Unable to connect to " + sys.argv[1]
