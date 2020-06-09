danny_branch = `git rev-parse --abbrev-ref HEAD`

# Deploy on the cluster by means of ansible, tracking the current branch
deploy: check-clean
  git push --set-upstream origin {{danny_branch}}
  ansible-playbook -i cluster.hosts deploy.yml -e danny_branch={{danny_branch}}

check-clean:
  @test -z "$(git status --porcelain)"

run-less:
  [ ! -f /danny.out ] || rm /tmp/danny.out
  cargo run > /tmp/danny.out || true
  less /tmp/danny.out

bench-cosine:
  cargo build --release
  LEFT=~/Datasets/GoogleWords/google-10k-left.txt RIGHT=~/Datasets/GoogleWords/google-10k-right.txt \
    hyperfine --min-runs 3 --parameter-scan num_threads 1 4 \
    'cargo run --release -- {num_threads} cosine 0.2 $LEFT $RIGHT'

bench-jaccard:
  cargo build --release
  hyperfine --min-runs 5 --parameter-scan num_threads 1 4 \
    'cargo run --release -- {num_threads} jaccard 0.5 ~/Datasets/Wikipedia/wiki-bow-10k-left.txt ~/Datasets/Wikipedia/wiki-bow-10k-right.txt'

merge BRANCH:
  git checkout {{BRANCH}}
  git rebase --interactive master
  git checkout master
  git merge {{BRANCH}}
  git push
  git push --delete origin {{BRANCH}}
  git branch -d {{BRANCH}}

@list-branches:
  git branch \
    --sort=-committerdate \
    --format "[%(committerdate:short)] %(HEAD) %(color:green)%(refname:short) %(color:yellow)%(committerdate:relative) %(color:reset)"

build-release:
  cargo build --release

data='~/Datasets/GoogleWords/google-1k.bin'

run-debug: build-release
  test ! -f /tmp/log || rm /tmp/log 
  cargo run --release --bin danny -- -r 0.6 -m cosine -a fixed-lsh --adaptive-k 10,12 {{data}} {{data}} 2> /tmp/log   
  less /tmp/log


check-gendiverse:
  rm -rf ~/Datasets/Wikipedia/wiki-bow-10k-diverse-exp.bin/
  cargo run --bin gendiverse --release -- -r 0.5 -t bag-of-words -s 9000 ~/datasets/Wikipedia/wiki-bow-10k-left.bin/ ~/Datasets/Wikipedia/wiki-bow-10k-left.exp ~/Datasets/Wikipedia/wiki-bow-10k-diverse-exp.bin/
  cargo run --bin expansion --release -- -r 0.5 -m jaccard ~/Datasets/Wikipedia/wiki-bow-10k-diverse-exp.bin/ ~/datasets/Wikipedia/wiki-bow-10k-left.bin/ 
  R -e "library(tidyverse); d <- read_delim('~/Datasets/Wikipedia/wiki-bow-10k-diverse-exp.exp', ' ', col_name=c('id', 'range', 'expansion')); qplot(expansion, data=d, geom='histogram'); ggsave('/tmp/hist.png')"
  open /tmp/hist.png


