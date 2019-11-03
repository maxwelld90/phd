import os
import sys
import fnmatch

for root, dirnames, filenames in os.walk(sys.argv[1]):
	for filename in fnmatch.filter(filenames, 'COMPLETED'):
		print root