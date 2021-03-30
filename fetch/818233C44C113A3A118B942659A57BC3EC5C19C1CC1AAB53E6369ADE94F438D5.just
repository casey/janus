set shell := ['python3', '-c']

foos := `print("foo" * 4)`

foo:
    print("This is python")
    print("{{foos}}")