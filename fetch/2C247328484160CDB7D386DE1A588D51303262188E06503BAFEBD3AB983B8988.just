build:
    cargo build

test:
    @just _test-faas-string
    @just _test-faas-binary
    @just _test-faas-custom

_test-faas-string:
    @echo -n 'faas_string: '
    @echo '{"content_type":"text","data":"Jane"}' | target/debug/faas_string > /dev/null &
    @head -1 /tmp/algoout | tee /dev/tty | jq -e '.result == "Hello Jane"' > /dev/null

_test-faas-binary:
    @echo -n 'faas_binary: '
    @echo '{"content_type":"binary","data":"aGVsbG8K"}' | target/debug/faas_binary > /dev/null &
    @head -1 /tmp/algoout | tee /dev/tty | jq -e '.result == "aGVsbG8K" and .metadata.content_type == "binary"' /dev/null

_test-faas-custom:
    @echo -n 'faas_custom: '
    @echo '{"content_type":"json","data":{"name":"Jane"}}' | target/debug/faas_custom > /dev/null &
    @head -1 /tmp/algoout | tee /dev/tty | jq -e '.result.msg == "Hello Jane"' > /dev/null

