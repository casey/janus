dev:
  clj -Anrepl

pom:
  clj -Spom

deploy-clojars: skinny-jar clojars

skinny-jar:
  clj -Apack mach.pack.alpha.skinny --no-libs --project-path struktur-dev.jar

clojars:
  export HISTFILE=/dev/null && clj -Adeploy "struktur-dev.jar"