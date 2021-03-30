build:
  ./gradlew deno

run:
  deno run --allow-read --no-check build/deno/@appName@.js

watch:
  deno run --unstable --watch --allow-read --no-check build/deno/@appName@.js

generate:
  dukat -d src/main/kotlin/deno src/main/kotlin/deno/lib.deno.d.ts

setup:
  brew install deno
  npm install -g dukat
