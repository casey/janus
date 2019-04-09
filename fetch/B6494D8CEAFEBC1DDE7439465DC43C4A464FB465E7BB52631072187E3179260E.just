clean:
	find . -type f -name "*.orig" -delete
	find . -type f -name "*.bk" -delete
	find . -type f -name ".*~" -delete
	find . -type f -name "*.pyc~" -delete
