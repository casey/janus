build:
  clang -Wall -Werror -g q.c -o q

run: build
  ./q
