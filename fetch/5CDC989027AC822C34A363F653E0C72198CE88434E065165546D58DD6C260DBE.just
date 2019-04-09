today t="index.md":
    #!/bin/bash
    dir={{invocation_directory()}}/$(date +'%Y-%m-%d')
    echo $dir
    mkdir -p $dir
    touch $dir/{{t}}
