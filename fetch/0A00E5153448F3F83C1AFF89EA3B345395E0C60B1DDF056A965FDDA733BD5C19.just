set shell := ['pwsh', '-c']

# It works in Mac OS X and Windows
hello-world:
    Write-Host 'Hello, World!'

os:
    Write-Host "{{os()}}"

os-family:
    Write-Host "{{os_family()}}"

# True
exit-true:
    bash -c '[ "00" == "00" ]' ; Write-Host $?

exit-false:
    bash -c '[ "01" == "00" ]' ; Write-Host $?

bash-date-second:
    bash -c 'date +%S'

do-while-bash:
    do \
    { \
    bash -c 's=$(date +%S); echo ${s}; [ ${s} == 00 ]' ; \
    $n=$? ; \
    Write-Host "${n}" ; \
    } \
    while ( ! $n )
