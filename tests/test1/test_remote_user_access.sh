docker-compose exec mysql-client bash -c 'mysql -v --user="${MYSQL_USER}" --password="${MYSQL_PASSWORD}" --host="mysql-server" --database="${MYSQL_DATABASE}" -e "SELECT 1"'
