debug_default := '-D DEBUG_TRACE_EXECUTION -D DEBUG_PRINT_CODE -D DEBUG_STRESS_GC -D DEBUG_LOG_GC'

build debug=debug_default:
  clang -pg -g {{debug}} -o main *.c

clean:
  rm -f main gprof.stats gmon.out

tags:
  ctags -R .
