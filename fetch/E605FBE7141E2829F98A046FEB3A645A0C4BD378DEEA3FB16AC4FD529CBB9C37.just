# Build minimized files for dist folder
build:
    #!/bin/bash
    html_minify(){
        if [ $(command -v html-minifier) ]; then
            echo -e "\e[33mMinifying\e[39m::\e[32mHTML\e[39m"
            $1 html-minifier --collapse-whitespace --remove-comments --remove-optional-tags --remove-redundant-attributes --remove-script-type-attributes --remove-tag-whitespace --use-short-doctype {} -o dist/{/}
        else
            if [ $(command -v npm) ]; then
                echo "npm install html-minifier -g"
            elif [ $(command -v yarn) ]; then
                echo "yarn global add html-minifier"
            else
                echo "Please install npm or yarn"
                echo "Then install html-minifier"
            fi
        fi
    }
    css_minify(){
        if [ $(command -v cssnano) ]; then
            echo -e "\e[33mMinifying\e[39m::\e[32mCSS\e[39m"
            $1 cssnano {} dist/css/{/.}.min.css
        else
            if [ $(command -v npm) ]; then
                echo "npm install cssnano-cli -g"
            elif [ $(command -v yarn) ]; then
                echo "yarn global add cssnano-cli"
            else
                echo "Please install npm or yarn"
                echo "Then install cssnano-cli"
            fi
        fi
    }
    js_minify(){
        if [ $(command -v terser) ]; then
            echo -e "\e[33mMinifying\e[39m::\e[32mJavascript\e[39m"
            $1 terser -c -m -o dist/js/{/.}.min.js {}
        else
            if [ $(command -v npm) ]; then
                echo "npm install terser -g"
            elif [ $(command -v yarn) ]; then
                echo "yarn global add terser"
            else
                echo "Please install npm or yarn"
                echo "Then install terser"
            fi
        fi
    }
    if [ $(command -v fd) ]; then
        # fd -e css -e js -e html --search-path dist -x sudo rm {}
        html_minify "fd -e html --search-path src     -a -x"
        css_minify  "fd -e css  --search-path src/css -a -x"
        js_minify   "fd -e js   --search-path src/js  -a -x"
    elif [ $(command -v fdfind) ]; then
        fdfind -e css -e js -e html --search-path dist -x sudo rm {}
        html_minify "fdfind -e html --search-path src     -a -x"
        css_minify  "fdfind -e css  --search-path src/css -a -x"
        js_minify   "fdfind -e js   --search-path src/js  -a -x"
    else
        if [ $(command -v pacman) ]; then
            echo "sudo pacman -S fd"
        elif [ $(command -v apt-get) ]; then
            echo "If you run Ubuntu 19.04 (Disco Dingo) or Debian Buster:"
            echo "    sudo apt-get install fd-find"
            echo "Otherwise:"
            echo "    curl -L https://github.com/sharkdp/fd/releases/download/v8.0.0/fd_8.0.0_amd64.deb -o fd_8.0.0_amd64.deb"
            echo "    sudo dpkg -i fd_8.0.0_amd64.deb"
        elif [ $(command -v dnf) ]; then
            echo "sudo dnf install fd-find"
        elif [ $(command -v xbps-install) ]; then
            echo "sudo xbps-install -S fd"
        elif [ $(command -v zypper) ]; then
            echo "sudo zypper install fd"
        elif [ $(command -v cargo) ]; then
            echo "cargo install fd-find"
        else
            echo "Please install fd"
            echo "    curl -L https://github.com/sharkdp/fd/releases/download/v8.0.0/fd-v8.0.0-x86_64-unknown-linux-gnu.tar.gz"
            echo "    tar -xzf fd.tar.gz"
            echo "    cp fd-v8.0.0-x86_64-unknown-linux-gnu/fd /usr/local/bin/"
            echo "    cp fd-v8.0.0-x86_64-unknown-linux-gnu/fd.1 /usr/local/share/man/man1/"
            echo "    mandb"
        fi
    fi

# Clean up the dist folder
clean:
    #!/bin/bash
    if [ $(command -v fd) ]; then
        fd -e css -e js -e html --search-path dist -x sudo rm {}
    elif [ $(command -v fdfind) ]; then
        fdfind -e css -e js -e html --search-path dist -x sudo rm {}
    else
        if [ $(command -v pacman) ]; then
            echo "sudo pacman -S fd"
        elif [ $(command -v apt-get) ]; then
            echo "If you run Ubuntu 19.04 (Disco Dingo) or Debian Buster:"
            echo "    sudo apt-get install fd-find"
            echo "Otherwise:"
            echo "    curl -L https://github.com/sharkdp/fd/releases/download/v8.0.0/fd_8.0.0_amd64.deb -o fd_8.0.0_amd64.deb"
            echo "    sudo dpkg -i fd_8.0.0_amd64.deb"
        elif [ $(command -v dnf) ]; then
            echo "sudo dnf install fd-find"
        elif [ $(command -v xbps-install) ]; then
            echo "sudo xbps-install -S fd"
        elif [ $(command -v zypper) ]; then
            echo "sudo zypper install fd"
        elif [ $(command -v cargo) ]; then
            echo "cargo install fd-find"
        else
            echo "Please install fd"
            echo "    curl -L https://github.com/sharkdp/fd/releases/download/v8.0.0/fd-v8.0.0-x86_64-unknown-linux-gnu.tar.gz"
            echo "    tar -xzf fd.tar.gz"
            echo "    cp fd-v8.0.0-x86_64-unknown-linux-gnu/fd /usr/local/bin/"
            echo "    cp fd-v8.0.0-x86_64-unknown-linux-gnu/fd.1 /usr/local/share/man/man1/"
            echo "    mandb"
        fi
    fi