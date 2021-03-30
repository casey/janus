hello:
    echo hello

find-sign:
    #!/usr/bin/env sh
    echo $0
    awk '
        {
            if (1 == beginsign)
            {
                print $0
            }
        }
        {
            # if ("# begin" == $0)
            if ($0 ~ /(begin)-(sign)/)
            {
                beginsign = 1
            }
        }
    ' $0
    # before begin
    # begin-sign
    # content
    # end

use-gcc:
    #!/usr/bin/env sh
    echo $0
    awk '
        {
            if (1 == beginsign)
            {
                print $0
            }
        }
        {
            # if ("# begin" == $0)
            if ($0 ~ /(begin)-(sign)/)
            {
                beginsign = 1
            }
        }
    ' $0 | gcc -x c -o "$0.$$.out" -
    $0.$$.out "$0" "$@"
    STATUS=$?
    rm $0.$$.out
    exit $STATUS
    # begin-sign
    #include <stdio.h>

    int main(int argc, char ** argv)
    {
        printf("Hello, world from c!\n");
        return 0;
    }
