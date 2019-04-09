# Watch and rebuild | alias jw
watch name='main' target='exe':
  watchexec -w lib -w bin './run_build.sh {{name}} {{target}}'

# Watch and rebuild | alias jw
w name='main' target='exe':
  watchexec -w lib -w bin './run_build.sh {{name}} {{target}}'

# Build | alias jb
build name='main' target='exe':  
  ./run_build.sh {{name}} {{target}}

# Build | alias jb
b name='main' target='exe':  
  ./run_build.sh {{name}} {{target}}

# Exec | alias je
@exec name='main' target='exe':
  dune exec ./bin/{{name}}.{{target}}

# Exec | alias je
@e name='main' target='exe':
  dune exec ./bin/{{name}}.{{target}}

# Install opam package
@opam-install name:
  opam install {{name}}

# Install opam package 
@oi name:
  opam install {{name}}  