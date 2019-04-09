name = 'plasma-demo.exe'
target_dir = '../target/release/'
rustflags = env_var_or_default('RUSTFLAGS', "")
features = env_var_or_default('FEATURES', "")


clean:
  cargo clean
  rm -f SDL2.dll

distclean: clean
  rm -f Plasma.{exe,scr} Plasma32.{exe,scr}

run:
  cargo run --release --features={{features}}

build:
  cargo build --release --features={{features}}

static:
  if [ "$MINGW_CHOST" = "i686-w64-mingw32" ]; \
    then just mingw-static32; \
  elif [ "$MINGW_CHOST" = "x86_64-w64-mingw32" ]; \
    then just mingw-static; \
  else \
    cargo build --features=static-link,use-pkgconfig,{{features}} --release; \
  fi

mingw-static:
  RUSTFLAGS="-C link-args=-s -L native=$(pwd -W)/sdl-2.0.8-windows/x86_64/gnu-mingw {{rustflags}}" cargo +nightly-x86_64-pc-windows-gnu build --features=static-link,{{features}} --release

mingw-static32:
  RUSTFLAGS="-C link-args=-s -L native=$(pwd -W)/sdl-2.0.8-windows/i686/gnu-mingw {{rustflags}}" cargo +nightly-i686-pc-windows-gnu build --features=static-link,{{features}} --release

install:
  if [ "$MINGW_CHOST" = "i686-w64-mingw32" ]; \
    then just mingw-install32; \
  elif [ "$MINGW_CHOST" = "x86_64-w64-mingw32" ]; \
    then just mingw-install; \
  else \
    @echo "Unsupported"; \
  fi

mingw-install: mingw-static
  install -T {{target_dir}}{{name}} Plasma.exe
  install -T {{target_dir}}{{name}} Plasma.scr

mingw-install32: mingw-static32
  install -T {{target_dir}}{{name}} Plasma32.exe
  install -T {{target_dir}}{{name}} Plasma32.scr
