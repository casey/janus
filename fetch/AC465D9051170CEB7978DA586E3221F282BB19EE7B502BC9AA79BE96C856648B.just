monitor-orient:
    xrandr --output LVDS-1 --auto --rotate normal --output VGA-1 --auto --left-of LVDS-1

monitor-off:
    xrandr --output VGA-1 --off

sound:
    alsamixer

mount-sdb1:
    sudo mount /dev/sdb1 /mnt/usbstick

umount-sdb1:
    sudo umount /dev/sdb1

update-arch:
    sudo pacman -Syuu

battery:
    upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage
