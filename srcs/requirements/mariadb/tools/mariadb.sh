#!/bin/ash

# stop if setup fail
set -e

# accept all incoming connection instead of only 127.0.0.1
if [ ! -e /etc/.setup ]; then
	cat <<-DONE >> /etc/my.cnf.d/mariadb-server.cnf
		[mysqld]
		bind-address=0.0.0.0
		skip-networking=0
		DONE
	touch /etc/.setup
fi

# create a new database
if [ ! -e /var/lib/mysql/.setup ]; then
	mysql_install_db --datadir=/var/lib/mysql \
	--skip-test-db --user=mysql --group=mysql \
	--auth-root-authentication-method=socket >/dev/null 2>&1

	# start a temp server to setup
	mariadbd-safe --skip-networking=0 --bind-address=127.0.0.1 >/dev/null 2>&1 &

	# wait till finish startup
	until mysqladmin ping -u root --silent >/dev/null 2>&1; do
		sleep 1
	done

	mariadb --protocol=socket -u root <<-DONE
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		FLUSH PRIVILEGES;
		DONE

		mariadb-admin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

		touch /var/lib/mysql/.setup
fi

exec "$@"
