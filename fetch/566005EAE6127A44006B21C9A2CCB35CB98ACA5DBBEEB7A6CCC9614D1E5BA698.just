compile:
    arduino-cli compile --fqbn="arduino:avr:pro" --verbose
    just clean

flash port="/dev/ttyUSB0":
    arduino-cli compile --fqbn="arduino:avr:pro" --port={{port}} --upload --verbose
    just clean

clean:
    rm -f firmware.arduino.*

find-boards:
    arduino-cli board list --format=json

monitor port="/dev/ttyUSB0":
    minicom --device {{port}}

