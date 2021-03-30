u8g2_revision := "3c6460a73f7f310c665cef0af1d2bac49bf6c655"
bitmap_fonts_revision := "5c101c91bf2ed0039aad02f9bf76ddb2018b1f21"

test-parser: _clone-u8g2 _clone-bitmap-fonts
    cd tools/test-bdf-parser; cargo test --release

_clone-u8g2: (_clone-font-repo "u8g2" "https://github.com/olikraus/u8g2.git" u8g2_revision)
_clone-bitmap-fonts: (_clone-font-repo "bitmap-fonts" "https://github.com/Tecate/bitmap-fonts.git" bitmap_fonts_revision)

_clone-font-repo directory repository revision:
    #!/usr/bin/env bash
    set -euxo pipefail
    if [ ! -d "target/fonts/{{directory}}" ]; then
        mkdir -p target/fonts/{{directory}}
        cd target/fonts/{{directory}}
        git clone {{repository}} .
        git checkout {{revision}}
    fi
