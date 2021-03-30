set shell := ['pwsh', '-c']

# It works in Mac OS X and Windows
hello-world:
    Write-Host 'Hello, World!'

os:
    Write-Host "{{os()}}"

os-family:
    Write-Host "{{os_family()}}"