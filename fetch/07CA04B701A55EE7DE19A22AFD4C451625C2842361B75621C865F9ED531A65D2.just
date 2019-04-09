
default:
  @just -l

install:
  npm install -g yarn prettier

lint:
  yarn eslint
  yarn tslint

storybook:
  yarn storybook

dev:
  yarn run-p storybook develop