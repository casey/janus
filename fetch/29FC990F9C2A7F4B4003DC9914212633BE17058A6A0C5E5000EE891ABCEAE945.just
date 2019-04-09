lox: build
    java -cp bin/lox com.craftinginterpreters.lox.Lox

generate_ast: build_tool
    java -cp bin/lox com.craftinginterpreters.tool.GenerateAst src/com/craftinginterpreters/lox

build: bin generate_ast
    javac -d bin/lox src/com/craftinginterpreters/lox/*.java

build_tool: bin
    javac -d bin/lox src/com/craftinginterpreters/tool/*.java

clean:
    @rm -rf bin

bin:
    @mkdir -p bin/lox