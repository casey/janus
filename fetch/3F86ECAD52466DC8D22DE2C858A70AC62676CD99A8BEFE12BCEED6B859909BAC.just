MODE := "release"
CFLAGS := "--release -Zbuild-std=core --target=msp430-none-elf"
TARGET := "target/msp430-none-elf/" + MODE + "/at2xt"
CLIPPY_LINTS := '-W clippy::if_not_else -W clippy::match_same_arms -W clippy::as_conversions \\
  -W clippy::indexing_slicing -W clippy::let_underscore_must_use'
# -W clippy::integer_arithmetic -W clippy::integer_division'

# Build AT2XT.
timer:
    cargo build {{CFLAGS}}
    msp430-elf-objdump -Cd {{TARGET}} > {{TARGET}}.lst
    msp430-elf-readelf -a --wide {{TARGET}} > {{TARGET}}.sym
    msp430-elf-size {{TARGET}}

# Build AT2XT and extra artifacts.
timer-extra:
    cargo rustc {{CFLAGS}} -- --emit=obj={{TARGET}}.o,llvm-ir={{TARGET}}.ll
    msp430-elf-objdump -Cd {{TARGET}} > {{TARGET}}.lst
    msp430-elf-readelf -a --wide {{TARGET}} > {{TARGET}}.sym
    msp430-elf-objdump -Cd {{TARGET}}.o > {{TARGET}}.o.lst
    msp430-elf-readelf -a --wide {{TARGET}}.o > {{TARGET}}.reloc
    msp430-elf-size {{TARGET}}

# Run clippy on AT2XT.
clippy:
  cargo clippy {{CFLAGS}} -- {{CLIPPY_LINTS}}

# Run clippy on AT2XT- pedantic mode (many lints won't apply).
clippy-pedantic:
  cargo clippy {{CFLAGS}} -- -W clippy::pedantic

# Combine with: just clippy-restriction 2>&1 | grep https:// | tr -s " " | sort | uniq?
# Run clippy on AT2XT- restriction mode (many lints won't apply).
clippy-restriction:
  cargo clippy {{CFLAGS}} -- -W clippy::restriction

# Fix warnings in AT2XT.
fix:
  cargo fix {{CFLAGS}}

# Fix warnings and attempt to apply clippy suggestions (nightly only).
fix-clippy:
  cargo clippy --fix -Zunstable-options {{CFLAGS}}

# Format AT2XT source.
fmt:
  cargo fmt

# Remove AT2XT and dependencies.
clean:
    cargo clean

# Upload firmware to AT2XT board using MSP-EXP430G2.
prog:
    mspdebug rf2500 "prog {{TARGET}}"

# Internal target for comparing the assembly output of two commits of AT2XT.
_diff-asm:
  #!/bin/sh
  set -e

  export CARGO_TARGET_DIR=diff-asm/target
  STAGING=diff-asm/staging

  prepare() {
      mkdir -p $CARGO_TARGET_DIR
      mkdir $STAGING
  }

  # build name suffix
  build() {
      if [ $# -lt 1 ]; then
          echo "Must supply artifact name to build."
          exit 4
      fi

      if [ $# -lt 2 ]; then
          SUFFIX=""
      else
          SUFFIX="-$2"
      fi

      FINAL_BINARY=$CARGO_TARGET_DIR/msp430-none-elf/release/$1
      ARTIFACT_PREFIX=$STAGING/$1''$SUFFIX

      cargo rustc --release --target=msp430-none-elf -- --emit=asm=$ARTIFACT_PREFIX.rs.lst,obj=$ARTIFACT_PREFIX.o || true
      msp430-elf-objdump -Cd $FINAL_BINARY > $ARTIFACT_PREFIX.lst
      msp430-elf-readelf -s --wide $FINAL_BINARY > $ARTIFACT_PREFIX.sym
      msp430-elf-objdump -Cd $ARTIFACT_PREFIX.o > $ARTIFACT_PREFIX.o.lst
      msp430-elf-readelf -r --wide $ARTIFACT_PREFIX.o > $ARTIFACT_PREFIX.reloc
      msp430-elf-size $FINAL_BINARY > $ARTIFACT_PREFIX.size
      cp $FINAL_BINARY $ARTIFACT_PREFIX
  }

  # commit_mode name commit1 commit2
  commit_mode() {
      if [ $# -lt 3 ]; then
          echo "Must supply artifact name to build, and two commit ids."
          exit 5
      fi

      echo "Running compare in commit mode."
      git checkout $2
      build $1
      git checkout $3
      build $1 1
      git diff $2 $3 > $STAGING/$1''$SUFFIX.rs.diff || true
      git checkout @{-2}
  }

  # stash_mode name
  stash_mode() {
      echo "Running compare in stash mode."
      git stash
      build $1
      git checkout -b diff-asm
      git stash pop
      build $1 1
      REV=`git rev-parse --short HEAD`
      git commit -am "diff-asm target"
      git diff @{-1} diff-asm -- > $STAGING/$1''$SUFFIX.rs.diff || true
      REV_NEW=`git rev-parse --short HEAD`
      DIFF_ASM_DIR_NAME=diff-asm/$REV-$REV_NEW
      git reset HEAD~1
      git checkout -
      git branch -D diff-asm
  }

  finalize() {
      mkdir -p $DIFF_ASM_DIR_NAME
      mv $STAGING/* $DIFF_ASM_DIR_NAME
      rmdir $STAGING
  }

  prepare

  if [ $# -eq 0 ]; then
      if git diff --quiet; then
          echo "No changes to compare!"
          exit 1
      fi

      stash_mode at2xt
  elif [ $# -eq 2 ]; then
      if ! git diff --quiet; then
          echo "Tree has modified content!"
          exit 2
      fi

      DIFF_ASM_DIR_NAME=diff-asm/`git rev-parse --short $1`-`git rev-parse --short $2`
      commit_mode at2xt $1 $2
  else
      echo "Usage: $0 [commit1 commit2]"
      exit 3
  fi

  finalize
