# HardworkingBob

Hardworking Bob is a hardworking guy who listens to whatever the heck you say on skype.

This was a fork of [basil](https://github.com/pbrisbin/basil) , but then I wanted the plugin framework to change,
and I wanted to remove some default email sending stuff from the code.

## What can Bob do ?

Anything. You want Bob to loot a bank for you ? No problem. You write a micro plugin that listens to skype messages
and loots a bank on cue. It's really simple if you know minimal Ruby . Look at some sample plugins.

## Getting started

~~~ { .bash }
git clone https://github.com/emilsoman/hardworkingbob.git
cd hardworkingbob
cp config/example.yml config/config.yml
bundle install
bundle exec bin/hardworkingbob
~~~
