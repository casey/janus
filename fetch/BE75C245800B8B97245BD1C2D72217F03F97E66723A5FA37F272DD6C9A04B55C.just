migrate:
	diesel migration run
revert:
	diesel migration revert
reset:
	@echo "         ABOUT TO NUKE MYSQL"
	@echo "IF YOU'RE NOT SURE WHERE, ASSUME PROD"
	@echo "HIT ^C IN THE NEXT 5 SECONDS TO CANCEL"
	@sleep 5
	diesel database reset
