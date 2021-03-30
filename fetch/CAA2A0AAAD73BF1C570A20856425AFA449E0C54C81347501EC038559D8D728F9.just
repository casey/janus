set shell := ["powershell.exe", "-c"]

dev-exp:
    cd {{justfile_directory()}}/expenses; flutter run -d windows