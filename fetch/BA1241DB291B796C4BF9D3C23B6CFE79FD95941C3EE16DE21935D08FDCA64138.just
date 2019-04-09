@_default:
    just -l

# removes all build artifacts
clean:
    rm -rf **/*.jar **/*.kexe
