# Dev commands

run:
	diesel migration run --database-url=postgres://poggit:123456@127.0.0.1:8079/poggit
redo:
	diesel migration redo --database-url=postgres://poggit:123456@127.0.0.1:8079/poggit
revert:
	diesel migration revert --database-url=postgres://poggit:123456@127.0.0.1:8079/poggit
list:
	diesel migration list --database-url=postgres://poggit:123456@127.0.0.1:8079/poggit
