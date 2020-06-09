# Removes public directory
clean:
    #!/bin/bash
    if [ -d public ]; then
        sudo rm -dR public
    else 
        echo "Already clean"
    fi

# Update Webpages
update:
    #!/bin/bash
    if [ $(git rev-parse HEAD) = $(git ls-remote $(git rev-parse --abbrev-ref @{u} | sed 's/\// /g') | cut -f1) ]; then
        echo "Up to date"
    else
        git pull --ff-only
        zola build
        zola index -t tantivy -o $PWD
        brotli_comp() {
            if [ $(command -v brotli) ]; then
                echo -e "\e[33mCompressing\e[39m::\e[32mBrotli\e[39m"
                $1 brotli --best -kf {}
            else
                echo -e "\e[31mPlease install brotli\e[33m"
                if [ $(command -v pacman) ]; then
                    echo "sudo pacman -S brotli"
                elif [ $(command -v apt-get) ]; then
                    echo "sudo apt-get install brotlii"
                else 
                    echo "yum install pcre-devel cmake -y"
                    echo "cd /usr/local/src"
                    echo "git clone https://github.com/google/brotli.git"
                    ehco "cd brotli"
                    echo "git checkout v1.0"
                    echo "./configure-cmake"
                    echo "make && make install"
                fi
            fi
        }
        gzip_comp(){
            if [ $(command -v gzip) ]; then
                echo -e "\e[33mCompressing\e[39m::\e[32mGzip\e[39m"
                $1 gzip --best -kf {}
            else
                echo -e "\e[31mPlease install gzip\e[33m"
                if [ $(command -v pacman) ]; then
                    echo "sudo pacman -S gzip"
                elif [ $(command -v apt-get) ]; then
                    echo "sudo apt-get install gzip"
                elif [ $(command -v yum) ]; then
                    echo "yum install gzip"
                elif [ $(command -v dnf) ]; then
                    echo "sudo dnf install gzip"
                elif [ $(command -v zypper) ]; then
                    echo "sudo zypper install gzip"
                else
                    echo "Please install gzip"
                fi
            fi
        }
        html_minify(){
            if [ $(command -v html-minifier) ]; then
                echo -e "\e[33mMinifying\e[39m::\e[32mHTML\e[39m"
                $1 html-minifier --collapse-whitespace --remove-comments --remove-optional-tags --remove-redundant-attributes --remove-script-type-attributes --remove-tag-whitespace --use-short-doctype {} -o {}
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
        
        if [ $(command -v fd) ]; then
            html_minify "fd -e html --search-path public -a -x"
            brotli_comp "fd -e html -e css -e js -e ico --search-path public -a -x"
            gzip_comp "fd -e html -e css -e js -e ico --search-path public -a -x"
        elif [ $(command -v fdfind) ]; then
            html_minify "fdfind -e html --search-path public -a -x"
            brotli_comp "fdfind -e html -e css -e js -e ico --search-path public -a -x"
            gzip_comp "fdfind -e html -e css -e js -e ico --search-path public -a -x"
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
    fi

# Prepare and push
push:
    #!/bin/bash
    css_minify(){
        if [ $(command -v cssnano) ]; then
            echo -e "\e[33mMinifying\e[39m::\e[32mCSS\e[39m"
            $1 cssnano {} {.}.min.css
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
            $1 terser -c -m -o {.}.min.js {}
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
        fd -e min.css -e min.js -x sudo rm {}
        css_minify "fd -e css --search-path static/css -a -x"
        js_minify  "fd -e js  --search-path static/js  -a -x"
    elif [ $(command -v fdfind) ]; then
        css_minify "fdfind -e css --search-path static/css -a -x"
        js_minify  "fdfind -e js  --search-path static/js  -a -x"
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
