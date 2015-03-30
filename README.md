# Linked Open Data Monitor

LODMonitor is a service that monitors the health and availability of linked open data resources.

![screen shot 2015-03-30 at 3 15 39 pm](https://cloud.githubusercontent.com/assets/111218/6908050/b848e92c-d6ef-11e4-86db-b1b13b0c1eee.png)

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
