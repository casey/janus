help:
  @just --list

# run from source
run:
  clojure -Srepro -M -m app.core

compile:
  mkdir -p classes
  clojure -Srepro -M -e "(compile 'app.core)"

# use buggy version of uberdeps
uberjar-incorrect:
  mkdir -p classes
  clojure -Srepro -Sdeps '{:aliases {:uberjar {:replace-paths [] :replace-deps {uberdeps/uberdeps {:mvn/version "1.0.2"}}}}}' -M:uberjar -m uberdeps.uberjar --aliases uberjar

uberjar:
  mkdir -p classes
  clojure -Srepro -Sdeps '{:aliases {:uberjar {:replace-paths [] :replace-deps {uberdeps/uberdeps {:mvn/version "1.0.3"}}}}}' -M:uberjar -m uberdeps.uberjar --aliases uberjar

# run from uberjar
run-uberjar:
  java -cp target/depslink3_2.jar clojure.main -m app.core

# demonstrate error when not replacing paths
replace-paths-error:
  clojure -Srepro -Sdeps '{:aliases {:blank {:replace-deps {}}}}' -M:blank

# demonstrate fix when replacing paths
replace-paths:
  clojure -Srepro -Sdeps '{:aliases {:blank {:replace-deps {} :replace-paths []}}}' -M:blank
