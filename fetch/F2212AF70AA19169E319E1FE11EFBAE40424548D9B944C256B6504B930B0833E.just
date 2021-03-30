alias i := install
alias o := open

install:
    pod deintegrate
    rm -rf Quickstart.xcworkspace
    pod install --repo-update

open:
	open Quickstart.xcworkspace
