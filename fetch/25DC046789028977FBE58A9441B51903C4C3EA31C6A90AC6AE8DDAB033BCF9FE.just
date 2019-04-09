# start samba server
samba_start:
	konsole -e 'sh -c "cd ~; (just  __samba_start); read -p \"press any key...\" -n1 -s" 1>1 2>2' &


__samba_start:
	sudo systemctl start nmb.service
	sudo systemctl start smb.service
	sudo systemctl status nmb.service | cat
	sudo systemctl status smb.service | cat


# stop samba server
samba_stop:
	konsole -e 'sh -c "cd ~; (just  __samba_stop); read -p \"press any key...\" -n1 -s" 1>1 2>2' &


__samba_stop:
	sudo systemctl stop nmb.service
	sudo systemctl stop smb.service


# start vnc server
vncserver:
	x11vnc -display :0


# run proyect i3 dwd
i3_dwd:
	cd /home/maiquel/inet.prj/web/dwd/i3; make
