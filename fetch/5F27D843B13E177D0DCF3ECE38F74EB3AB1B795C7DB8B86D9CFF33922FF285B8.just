# Credo used outside of mix as a standalone archive. Installation instructions:
# https://github.com/rrrene/credo#using-credo-as-stand-alone
tests exercise_filename test_filename test_helper:
  mix format --dot-formatter ~/exercism/elixir/.formatter.exs
  elixir -e "ExUnit.start();" -r {{exercise_filename}} -r {{test_helper}} -r {{test_filename}}
  mix credo --strict {{exercise_filename}}
