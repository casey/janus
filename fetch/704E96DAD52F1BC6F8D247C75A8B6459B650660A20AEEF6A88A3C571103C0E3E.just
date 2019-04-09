check-branch:
    if [ `git rev-parse --abbrev-ref HEAD` != "source" ]; then echo "Not on source branch..." && exit 1; fi

build: build-blog build-resume

build-blog: check-branch
    cobalt build

build-resume: check-branch
    mkdir -p build/resume
    hackmyresume BUILD resume/resume.json TO resume.html -t /usr/lib/node_modules/jsonresume-theme-slick/
    mv resume.html build/resume/index.html
    cp resume/jakubmatraszek.jpg build/resume/jakubmatraszek.jpg

update-last-modified: check-branch
    sed -ri "s/([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2})\:([0-9]{2})\:([0-9]{2})/$(date -u +"%Y-%m-%dT%H:%M:%S")/" resume/resume.json
    git add resume/resume.json
    git commit -m "Bump lastModified in resume.json"

deploy-resume: update-last-modified build-resume deploy

deploy-blog: build-blog deploy

deploy:
    git checkout master
    git pull origin master
    git checkout source
    git push origin source
    ghp --branch master --message "Build site" build
    git checkout master
    git push origin master

clean:
    rm -rf build

# Local Variables:
# mode: makefile
# End:
# vim: set ft=make :
