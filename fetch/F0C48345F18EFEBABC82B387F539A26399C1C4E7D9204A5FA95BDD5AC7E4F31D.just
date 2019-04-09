# wonderful colors
green  = "\\033[0;32m"
cyan   = "\\033[0;36m"
clear  = "\\033[0m"

# the current version number in package.json
currentVersion = `cat package.json | grep version | cut -d "\"" -f4`

# the current branch in git
currentBranch = `git rev-parse --abbrev-ref HEAD`

# the number of unstaged changes in git
currentStatus = `git status -s | wc -l | awk '$1=$1'`

# lists the tasks (ensure this is task #1 in the list)
@_list:
  just --list

# asks to set the new version number
@bump:
  echo "----------------------"
  echo "{{ green }}Version Bump Checklist{{ clear }}"
  echo "----------------------"
  echo
  echo "* haven't changed version yet: {{ cyan }}{{ currentVersion }}{{ clear }}"
  echo "* on master branch:            {{ cyan }}{{ currentBranch }}{{ clear }}"
  echo "* no uncommitted files:        {{ cyan }}{{ currentStatus }}{{ clear }}"
  echo "* CHANGELOG.md updated:        {{ cyan }}???{{ clear }}"
  echo
  yarn -s version

# pushes up to git
@push:
  git push
  git push --tags

# releases on marketplace
@publish:
  vsce publish

# This does nothing but echoes hello.
@hello:
  echo "hello!"

