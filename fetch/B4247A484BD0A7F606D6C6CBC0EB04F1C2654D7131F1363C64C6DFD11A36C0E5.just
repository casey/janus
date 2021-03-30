alias f := format
alias i := install
alias l := lint
alias o := open

format:
    swiftformat . --swiftversion 4.2

install:
    pod deintegrate
    rm -rf LiveApp.xcworkspace
    pod install

lint:
    swiftlint lint --path LiveApp --config ../.swiftlint.yml

open:
	open LiveApp.xcworkspace
