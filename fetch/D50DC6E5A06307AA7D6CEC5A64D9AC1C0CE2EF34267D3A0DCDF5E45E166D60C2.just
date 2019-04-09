args = ""
# args = "-w 9000 -h 6000"
browser = "google-chrome-stable"
image_viewer = "display"

all: check doc build test
clean:
	cargo clean
doc-open: doc
	cargo doc --open
install:
	cargo install --force
watch target="all":
	cargo watch -cs "just args=\"{{args}}\" image_viewer=\"{{image_viewer}}\" {{target}}"

asmjs:
	EMMAKEN_CFLAGS="-s USE_SDL=2" cargo build --release --target=asmjs-unknown-emscripten
build:
	cargo build --release
check:
	cargo check
doc:
	cargo doc
gui SCENE="testing":
	cargo run --release -- scenes/{{SCENE}}.scn {{args}}
gui-debug SCENE="testing":
	cargo run -- scenes/{{SCENE}}.scn {{args}}
open SCENE="testing":
	cargo run --release -- scenes/{{SCENE}}.scn -o {{SCENE}}.png {{args}}
	{{image_viewer}} {{SCENE}}.png
open-debug SCENE="testing":
	cargo run -- scenes/{{SCENE}}.scn -o {{SCENE}}.png {{args}}
	{{image_viewer}} {{SCENE}}.png
test:
	cargo test --release
run SCENE="testing":
	cargo run --release -- scenes/{{SCENE}}.scn -o {{SCENE}}.png {{args}}

flamegraph SCENE="testing":
	cargo build --release --no-default-features
	mkdir -p profiling/flamegraph
	cd profiling/flamegraph && perf record -F 100 -a -g -- ../../target/release/raytracer ../../scenes/{{SCENE}}.scn -o {{SCENE}}.png {{args}}
	cd profiling/flamegraph && perf script > raytracer.perf
	stackcollapse-perf profiling/flamegraph/raytracer.perf > profiling/flamegraph/raytracer.folded
	grep render profiling/flamegraph/raytracer.folded | flamegraph > profiling/flamegraph/render.svg
	cat profiling/flamegraph/raytracer.folded | flamegraph > profiling/flamegraph/raytracer.svg
	{{browser}} profiling/flamegraph/flamegraph.svg
