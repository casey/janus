default:
	just -l

demo: clean setup attack check run

clean:
	rm -f good.sh.bao

setup:
	bao encode good.sh good.sh.bao

attack:
	cat bad.sh >> good.sh.bao

check:
	#!/usr/bin/env bash
	HAVE=`bao hash --encoded good.sh.bao`
	WANT=`bao hash good.sh`
	if [[ $HAVE != $WANT ]]; then
		echo "Bad hash: $HAVE != $WANT"
		echo "Exiting..."
		exit 1
	else
		echo "Good hash!"
		exit 0
	fi

run:
	#!/usr/bin/env python3

	import struct, tempfile, subprocess

	with open('good.sh.bao', 'rb') as f:
		bytes = f.read()

	(length,) = struct.unpack('<Q', bytes[:8])
	
	rest = bytes[8:]

	script = rest[-length:]

	tmp = tempfile.NamedTemporaryFile()

	tmp.write(script)
	tmp.flush()

	subprocess.call(['chmod', '+x', tmp.name])

	out = subprocess.check_output(['cat', tmp.name])

	subprocess.call([tmp.name])
