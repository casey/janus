list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

fetch:
	cd dat/raw && wget -mk http://artscene.textfiles.com/artpacks/;:
	cd dat/raw && wget -mk http://artscene.textfiles.com/acid/;:
	cd dat/raw && wget -mk http://artscene.textfiles.com/ice/;:

unpack:
	rm -rf dat/unpacked
	mkdir dat/unpacked
	./main unpack

clean:
	rm -rf dat/clean
	mkdir dat/clean
	rm -f *.log
	./main clean
	find dat/clean -depth -empty -delete

classify:
	rm -rf dat/classified
	mkdir dat/classified
	./main classify

render:
	rm -rf dat/rendered
	mkdir dat/rendered
	./main render

compile:
	rm -rf dat/compiled
	mkdir dat/compiled
	./main compile

preprocess:
	rm -rf dat/preprocessed
	mkdir dat/preprocessed
	./main preprocess

train:
	rm -rf dat/checkpoints
	mkdir dat/checkpoints
	./main train

sample:
	rm -rf dat/samples
	mkdir dat/samples
	./main sample

rasterize:
	#rm -rf dat/rasterized/
	#mkdir dat/rasterized
	#./main rasterize

pack:
	rm -rf dat/packs
	mkdir dat/packs
	./main pack

info:
	./main info

watch:
	watch -n 0.5 nvidia-smi

.PHONY: list fetch unpack
