# Linked Open Data Monitor

LODMonitor is a service that monitors the health and availability of linked open data resources.

![screen shot 2015-03-31 at 10 16 43 am](https://cloud.githubusercontent.com/assets/111218/6924689/1800b940-d78f-11e4-81ab-62ec039ad505.png)

## Install

lodmonitor is a simple Ruby on Rails application. 

```
$ bundle install
$ rake db:migrate
$ bundle exec rails s
```

### With docker

lodmonitor supports [docker-compose](http://docs.docker.com/compose/). If you've installed docker and docker-compose, getting lodmonitor running is as simple as:

```
$ docker-compose up
```

lodmonitor is also on [registry.hub.docker.com](https://registry.hub.docker.com), and can be run as, e.g.:

```
$ docker run -p 80 cbeer/lodmonitor
```
