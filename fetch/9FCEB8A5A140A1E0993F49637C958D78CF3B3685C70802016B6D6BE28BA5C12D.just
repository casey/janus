build:
  tsc --build .

prepack: build

clean:
  tsc --build --clean .