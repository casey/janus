run:
  GOOS=linux GOARCH=arm GOARM=7 go build -o temperature-collector_armv7 .
  rsync temperature-collector_armv7 pi@192.168.230.3:.
  ssh -t pi@192.168.230.3 'sh -c "sudo ./temperature-collector_armv7"'
