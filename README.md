# Linked Open Data Monitor

LODMonitor is a service that monitors the health and availability of linked open data resources.

![screen shot 2015-03-07 at 11 46 00 am](https://cloud.githubusercontent.com/assets/111218/6543011/9b95cb66-c4bf-11e4-8bb7-013caa99961c.png)

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