IP Monitoring System Setup Guide

Requirements:

Ruby
PostgreSQL
Redis

Initial Setup:

```
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
```

Starting the Application:

start background workers: `bundle exec sidekiq -r ./app.rb -C config/sidekiq.yml`
launch the application: `rackup config.ru`

API Testing Commands:

create: `curl -X POST http://localhost:9292/ips -d "ip=192.168.1.1&enabled=true"`
enable: `curl -X POST http://localhost:9292/ips/1/enable`
disable: `curl -X POST http://localhost:9292/ips/1/disable`
stats: `curl http://localhost:9292/ips/1/stats?time_from=2023-09-19T00:00:00Z&time_to=2023-09-19T23:59:59Z`
delete: `curl -X DELETE http://localhost:9292/ips/1`
