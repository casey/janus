set shell := ["powershell.exe", "-c"]

build target='..\plugins\plug_gimp.dll':
    cargo build
    if (Test-Path {{target}}) { Remove-Item {{target}} -Force -ErrorAction Ignore }
    Copy-Item target\debug\plug_gimp.dll ..\plugins\

clean:
    if (Test-Path target) { Remove-Item target -Recurse -ErrorAction Ignore }