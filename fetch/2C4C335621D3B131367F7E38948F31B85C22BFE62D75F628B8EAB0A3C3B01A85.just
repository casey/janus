version := 0.1.0
tarball := edmv-$(version).tar.gz
tardir  := edmv-$(version)

release:
	rm -f $(tarball)
	mkdir $(tardir)
	cp edmv $(tardir)
	tar zcvf $(tarball) $(tardir)
	rm -rf $(tardir)

checksum:
	openssl dgst -rmd160 $(tarball)
	openssl dgst -sha256 $(tarball)
