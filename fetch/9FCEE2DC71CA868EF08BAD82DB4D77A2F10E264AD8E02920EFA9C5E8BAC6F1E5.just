run:
	build/lispy

build:
	cmake --build build

format:
	clang-format -i --style=file *.hpp *.cpp
