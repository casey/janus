run:
    python doit.py
gecko:
    wget https://github.com/mozilla/geckodriver/releases/download/v0.21.0/geckodriver-v0.21.0-linux64.tar.gz
    tar xvfz geckodriver-v0.21.0-linux64.tar.gz
    mv geckodriver ~/.local/bin 
