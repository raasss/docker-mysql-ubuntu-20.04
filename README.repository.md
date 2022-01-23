**Maintained by**: [raasss](https://github.com/raasss/)


# Quick reference

-	Issues can be filed at [GitHub Issues](https://github.com/raasss/docker-mysql-ubuntu-20.04/issues).

-	Supported architectures are: `linux/amd64`, `linux/arm/v7`, `linux/arm64` 

-	Source of this content can be found at [README.docker.io.md](https://github.com/raasss/docker-mysql-ubuntu-20.04/blob/main/README.docker.io.md)

# Introduction

MySQL Server is one of the most popular open source relational databases. It’s made by the original developers of MySQL and guaranteed to stay open source. It is part of most cloud offerings and the default in most Linux distributions. ([more info](https://dev.mysql.com/doc/))

# Quickstart guide

Starting a mysql instance with the latest version is simple via [`docker-compose`](https://github.com/docker/compose). If you don't have docker-compose tool installed, please go [here](https://docs.docker.com/compose/install/) and follow instractions.

Example `docker-compose.yml` for `mysql`:

```yaml
version: '3.7'

networks:
  private:
    driver: bridge

services:
  mysql:
    image: raasss/mysql-ubuntu-20.04:latest
    networks:
      - private
    ports:
      - "3306"
    environment:
      - MYSQL_SERVER_CONF_1=mysqld:key_buffer_size:16M
      - MYSQL_SERVER_CONF_2=mysqld:slow_query_log:1
      - MYSQL_SERVER_CONF_2=mysqld:long_query_time:2
      - MYSQL_SERVER_CONF_2=mysqld:log_queries_not_using_indexes:1
```

In your current working directory create `docker-compose.yml` file.

Run docker-compose and services should be up soon:

```console
$ docker-compose up -d
```

We can find port where mysql service listen for connections like this:

```console
$ docker-compose port mysql 3306
0.0.0.0:49154
```

In this example we can configure any mysql client with host `0.0.0.0:49154`.

# Advance guide

## Container shell access

The `docker-compose exec` command allows you to run commands inside a Docker container.

The following command line will give you a bash shell inside your `mysql` container as root:

```console
$ docker-compose exec mysql bash
```

## Access logs

The log is available through Docker's container log:

```console
$ docker-compose logs mysql -f
```

You can omit `-f` if you don't want to tail logs in realtime.

## Customizing via environment variables

Customization of `/etc/mysql/mysql.conf.d/mysqld.cnf` file in docker image is implemented.

This file is standard configuration files in INI format. Every INI file is consisted of `<section>` and `<key> = <value>` pairs.

This is how trimmed version of `php.ini` file looks like:

```ini
[mysqld]
#
# * Fine Tuning
#
key_buffer_size		= 16M
max_allowed_packet	= 64M
thread_stack		= 256K

#
# * Logging and Replication
#
# Both location gets rotated by the cronjob.
#
# Log all queries
# Be aware that this log type is a performance killer.
general_log_file        = /var/log/mysql/query.log
general_log             = 0

#
# Here you can see queries with especially long duration
slow_query_log		= 1
slow_query_log_file	= /var/log/mysql/mysql-slow.log
long_query_time = 2
log-queries-not-using-indexes = on
```

Here we can see 1 sections `mysqld` and multiple `key=value` pairs:

- `key_buffer_size = 16M`
- `slow_query_log = 1`
- `long_query_time = 2`
- `log-queries-not-using-indexes = on`

To configure files above you need to add environment variables in format `MYSQL_SERVER_CONF_*`.

Value of these environment variables need to be in format `<section>:<key>:<value>` as can be found in example `docker-compose.yml` file above.

## Pull service images
```console
docker-compose pull
```

## Backup database inside docker to local filesystem
```console
docker-compose exec -u root mysql mysqldump --add-drop-database --add-drop-table --single-transaction --verbose mydatabase > mydatabase.sql
```

## Restore database from local filesystem to docker
```console
cat mydatabase.sql | docker-compose exec -T -u root mysql mysql mydatabase
```

## Start services
```console
docker-compose start
```

## List containers
```console
docker-compose ps
```

## Create and start containers
```console
docker-compose up -d
```

## Stop services
```console
docker-compose stop
```

## Stop and remove containers, networks, images, and volumes
```console
docker-compose down --volumes --remove-orphans
```
