#!/bin/bash

cd /home/app/webapp

export RAILS_ENV=production

sudo -u app bash -c "RAILS_ENV=production bundle exec rake db:migrate"