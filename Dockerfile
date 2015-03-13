FROM phusion/passenger-ruby22


ENV HOME /home/app/webapp

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default

ADD webapp.conf /etc/nginx/sites-enabled/default
ADD secret_key.conf /etc/nginx/main.d/secret_key.conf

RUN mkdir /home/app/webapp
ADD . /home/app/webapp

WORKDIR /home/app/webapp

RUN bundle install --deployment
RUN rake db:migrate

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]
