# Commands

update: pull lock

pull:
	cd straight/repos; \
	parallel --timeout 30 --bar --halt-on-error soon,fail,1 'cd {}; git pull --quiet' ::: *

lock:
	emacs --batch -q -l ./load-packages.el --eval "(straight-freeze-versions t)"
