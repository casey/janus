# https://github.com/casey/just


# List available receipes
@list:
  just --list


# Clean unnecessary files
clean:
  rm -rf experiments/test/*
  rm -f codalab_submission.zip
