check:
	art check

git-verify: # make sure git is clean and on master
	git branch | grep '* master'
	git diff --no-ext-diff --quiet --exit-code

push: git-verify 
	art export html -o _gh-pages
	cd _gh-pages && git commit -am "update" && git push origin gh-pages && cd ..
	git push origin master

