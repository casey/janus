default: build

build:
	go install cmd/ltrain.go

build_arm:
	env GOOS=linux GOARCH=arm GOARM=6 go build -o bin/arm/dumpLTrainsForLCD cmd/dumpLTrainsForLCD.go
	env GOOS=linux GOARCH=arm GOARM=6 go build -o bin/arm/printStatusOfLTrain cmd/printStatusOfLTrain.go

run:
	ltrain -key `decrypt $$ARG1`

fmt:
	go fmt *.go
	go fmt cmd/*.go

montrose:
	ltrain -key `decrypt $$ARG1` | grep -i montrose

protoc:
	protoc --go_out=. transit_realtime/gtfs-realtime.proto
	cd nyct_subway && protoc --go_out=. nyct-subway.proto && cd ..
	sed -i'' -e 's/import transit_realtime "."/import "github.com\/aoeu\/mta\/transit_realtime"/' nyct_subway/nyct-subway.pb.go
