set shell := ['pwsh', '-c']

install-rust:
    scoop uninstall rust --global
    scoop install rust --global

do-while-install-rust:
    do \
    { \
    scoop uninstall rust --global ; \
    scoop install rust --global ; \
    Get-Command rustc ; \
    $n=$? ; \
    Write-Host "${n}" ; \
    } \
    while ( ! $n )

pwsh-processes:
    Get-CimInstance -ClassName Win32_Process -Filter 'Name = "pwsh.exe"'

pwsh-processes-commandline:
    Get-CimInstance -ClassName Win32_Process -Filter 'Name = "pwsh.exe"' | Select-Object CommandLine

pwsh-processes-commandline-scoop:
    Get-CimInstance -ClassName Win32_Process -Filter 'Name = "pwsh.exe" and CommandLine LIKE "%scoop%"' | Select-Object CommandLine
