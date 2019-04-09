# wengwengweng

run args = "":
	amulet {{args}}

export:
	rm -rf build
	mkdir -p build
	cd build; \
		cp ../icon.png icon.png; \
		amulet export -r -mac -windows -linux -html ..; \
		rm icon.png

loc:
	loc

