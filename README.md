hubot-hyper-devops
================================
Hubot script for hyper.sh devops


# Dependency

- hubot 2.19.0
- coffee-script@^1.12.6
- hyper client ([install](https://docs.hyper.sh/GettingStarted/install.html))


# Installation

## Install hubot

```
$ sudo npm install -g yo generator-hubot

$ mkdir myhubot
$ cd myhubot
$ yo hubot
```

## Install hubot-hyper-devops

In hubot project repo, run:

`$ npm install hubot-hyper-devops --save`

Then add **hubot-hyper-devops** to your `external-scripts.json`:

```json
[
  "hubot-hyper-devops"
]
```


# Debug

```
//use shell as adapter
HUBOT_LOG_LEVEL=debug  bin/hubot --name myhubot


//use slack as adapter
HUBOT_LOG_LEVEL=debug  bin/hubot --name myhubot --adapter slack
```
