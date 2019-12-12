update-readme:
	tail -n+15 src/lib.rs | head -n-2 | cut -c5- | sed -e 's/```ignore/```rust/g' > README.md
