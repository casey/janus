build_target := 'thumbv7em-none-eabihf'
test_target := 'thumbv7em-linux-eabihf'
openocd_config := '-f board/stm32l4discovery.cfg'
itm_freq := '80000000'

elf_name := `basename $(pwd)`
release_elf := "target/" + build_target + "/release/" + elf_name

# Check with clippy.
clippy:
	cargo clippy --target {{build_target}}

# Build the binary.
build:
	cargo build --target {{build_target}} --release

# Generate documentation.
doc:
	cargo doc --target {{build_target}}

# Generate README.md from src/lib.rs.
readme:
	cargo readme -o README.md

# Run tests.
test:
	RUST_TARGET_PATH=$(pwd) CROSS_COMPILE=arm-none-eabi- \
		xargo test --target {{test_target}}

# Clean up generated files.
clean:
	cargo clean
	rm -f tmp/heaptrace
	rm -f tmp/itmfifo

# Disassemble the binary.
inspect: build
	cargo objdump --target {{build_target}} --release --bin {{elf_name}} -- \
		-disassemble -demangle -s -all-headers | \
	pager

# Debug the connected device.
debugger:
	#!/usr/bin/env sh
	OPENOCD_MATCH="-x $(which openocd) -p tmp/openocd.pid"
	start-stop-daemon $OPENOCD_MATCH -K >/dev/null
	trap "start-stop-daemon $OPENOCD_MATCH --remove-pidfile -K" 0 1 2 3 15
	start-stop-daemon $OPENOCD_MATCH -d $(pwd) -mbCS -- {{openocd_config}}
	gdb-multiarch {{release_elf}} \
		-ex "target remote :3333" \
		-ex "monitor reset halt"

# Flash the binary to the connected device.
flash: build
	openocd {{openocd_config}} \
		-c "init" \
		-c "reset halt" \
		-c "flash write_image erase {{release_elf}} 0 elf" \
		-c "verify_image {{release_elf}} 0 elf" \
		-c "reset run" \
		-c "shutdown"

# Show SWO output of the connected device.
swo:
	#!/usr/bin/env sh
	ITMSINK_MATCH="-x $(which itmsink) -p tmp/itmsink.pid"
	ITMSINK_ARGS="-i tmp/itmfifo 0"
	if [ -n "$HEAPTRACE" ]; then
		truncate -s0 tmp/heaptrace
		ITMSINK_ARGS="$ITMSINK_ARGS 31:tmp/heaptrace"
	fi
	rm -f tmp/itmfifo
	mkfifo -m 0644 tmp/itmfifo
	start-stop-daemon $ITMSINK_MATCH -K >/dev/null
	trap "start-stop-daemon $ITMSINK_MATCH --remove-pidfile -K" 1 2 3 15
	start-stop-daemon $ITMSINK_MATCH -d $(pwd) -mbCS -- $ITMSINK_ARGS
	openocd {{openocd_config}} \
		-c "itm ports on" \
		-c "tpiu config internal tmp/itmfifo uart off {{itm_freq}}"
