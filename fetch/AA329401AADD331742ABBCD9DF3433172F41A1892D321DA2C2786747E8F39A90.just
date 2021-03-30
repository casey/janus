# List available receipes
@list:
  just --list

# Sync result data from cluster
get experiment_group host="meta":
  mkdir -p results/{{experiment_group}}/results
  rsync -a --info=progress2 --info=name0 {{host}}:htaa_experiments/results/{{experiment_group}}/results results/{{experiment_group}}
  rm results/{{experiment_group}}/_load_cache.csv

# Plot a result
plot experiment_group output_dir="plots":
  mkdir -p {{output_dir}}/{{experiment_group}}
  python -m hp_transfer_aa_experiments.analyse.plot_speedup \
    --results_path results/{{experiment_group}} \
    --output_dir {{output_dir}}/{{experiment_group}}
  python -m hp_transfer_aa_experiments.analyse.plot_failure_percent \
    --results_path results/{{experiment_group}} \
    --output_dir {{output_dir}}/{{experiment_group}}
  python -m hp_transfer_aa_experiments.analyse.plot_improvements \
    --results_path results/{{experiment_group}} \
    --output_dir {{output_dir}}/{{experiment_group}}

# Plot a result and open
ploto experiment_group output_dir="plots":
  just plot {{experiment_group}} {{output_dir}}
  okular {{output_dir}}/{{experiment_group}}/speedup_aggregate.pdf &

# Get results from cluster and plot
getplot experiment_group host="meta" output_dir="plots":
  just get {{experiment_group}} {{host}}
  just plot {{experiment_group}} {{output_dir}}

  # Get results from cluster and plot
getploto experiment_group host="meta" output_dir="plots":
  just getplot {{experiment_group}} {{output_dir}} {{host}}
  okular {{output_dir}}/speedup_aggregate.pdf &

fill from to approach="tpe" runtype="eval_reference":
  mkdir -p results/{{to}}/fcnet_aa/{{runtype}}/{{approach}}/
  mkdir -p results/{{to}}/xgb_aa/{{runtype}}/{{approach}}/
  mkdir -p results/{{to}}/svm_aa/{{runtype}}/{{approach}}/
  cp results/{{from}}/fcnet_aa/{{runtype}}/{{approach}} results/{{to}}/fcnet_aa/{{runtype}}/ -r
  cp results/{{from}}/svm_aa/{{runtype}}/{{approach}} results/{{to}}/svm_aa/{{runtype}}/ -r
  cp results/{{from}}/xgb_aa/{{runtype}}/{{approach}} results/{{to}}/xgb_aa/{{runtype}}/ -r
  rm results/{{to}}/_load_cache.csv

# Submit job
submit experiment_group benchmark runtypes approaches trajectory_ids adjustment_ids partition repeats max_parallel_jobs:
  #!/bin/bash
  set -e  # Stop on first failure

  python -m hp_transfer_aa_experiments.run.py \
    benchmark={{benchmark}} \
    runtype={{runtypes}} \
    approach={{approaches}} \
    trajectory_ids={{trajectory_ids}} \
    benchmark.benchmark.adjustment_id={{adjustment_ids}} \
    parition={{partition}} \
    seed=range\(0,{{repeats}}\) \
    max_jobs={{max_parallel_jobs}} \
    # todo config name
