step1:
	docker run hello-world

step2:
	docker pull nginx
	docker run --rm nginx

step2_1:
	docker run --rm -p 8080:80 nginx

step3:
	docker pull mysql:5.7
	docker run --name mysql -e MYSQL_ROOT_PASSWORD=mypass123 -d mysql:5.7
	docker pull phpmyadmin/phpmyadmin
	docker run --name phpmyadmin -d --link mysql:db -p 8081:80 phpmyadmin/phpmyadmin

step3_stop:
	docker stop mysql phpmyadmin
	docker rm mysql phpmyadmin

step4_pre:
	mkdir data

step4:
	docker run --name mysql -v $(PWD)/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=mypass123 -d mysql:5.7
	docker run --name phpmyadmin -d --link mysql:db -p 8081:80 phpmyadmin/phpmyadmin

step4_1:
	docker volume create mysqldata
	docker run --name mysql -v mysqldata:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=mypass123 -d mysql:5.7
	docker run --name phpmyadmin -d --link mysql:db -p 8081:80 phpmyadmin/phpmyadmin

step5_pre:
	mkdir html

step5:
	docker pull wordpress
	docker run --name mysql -v $(PWD)/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=mypass123 -d mysql:5.7
	docker run --name phpmyadmin -d --link mysql:db -p 8081:80 phpmyadmin/phpmyadmin
	docker run --name wordpress -v $(PWD)/html:/var/www/html -d --link mysql:mysql -p 8082:80 wordpress

step5_stop:
	docker stop mysql phpmyadmin wordpress
	docker rm mysql phpmyadmin wordpress

step6_pre:
	docker network create wpsite

step6:
	docker run --name mysql -v $(PWD)/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=mypass123 -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress --network wpsite -d mysql:5.7
	docker run --name phpmyadmin -d -e PMA_HOST=mysql -e MYSQL_ROOT_PASSWORD=mypass123 --network wpsite -p 8081:80 phpmyadmin/phpmyadmin
	docker run --name wordpress -v $(PWD)/html:/var/www/html -d -e WORDPRESS_DB_HOST=mysql:3306 -e WORDPRESS_DB_USER=wordpress -e WORDPRESS_DB_PASSWORD=wordpress --network wpsite -p 8082:80 wordpress

reset:
	rm -fr data html
	mkdir data
	mkdir html
	docker network rm wpsite
	docker volume rm mysqldata
