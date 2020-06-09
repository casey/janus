run: build execute rm

Os := os()

installer:
    #!/usr/bin/env python3
    import sys
    import os
    scriptpath = './'
    sys.path.append(os.path.abspath(scriptpath))
    import runner
    runner.set('{{Os}}')
    runner.install('java')
    runner.install('kotlin')
    runner.install('hub')
    
build:
    @kotlinc hello.kt -include-runtime -d hello.jar

execute:
    @java -jar hello.jar

rm:
    @rm -rf hello.jar

git-init:
    hub init
    hub create
    echo ".gradle/" > .gitignore
    echo ".vscode/" >> .gitignore
    echo "__pycache__/" >> .gitignore

git-reload:
    git rm -r --cached .
    git add .
    git commit -m "commit reload"
    git push
#No Soltion for github auth currently
#Path: ~/.ssh/github_rsa
git-auth:
    ssh-keygen
    ssh-agent -s
    ssh-add ~/.ssh/github_rsa
