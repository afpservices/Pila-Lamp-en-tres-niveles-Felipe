#Procedemos a la instalacion de MySQL

sudo apt update
apt install mysql-server -y


#Aqui procederemos a crear la base de datos 

sudo mysql

CREATE DATABASE WordPressBD DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

#Porcederemos a crear los usuarios de los dos frontend para que puedan acceder a la base de datos que hemos creado anteriormente 

CREATE USER 'Felipe'@'10.0.2.151' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON WordPressBD.* TO 'Felipe'@'10.0.2.151';

GRANT ALL PRIVILEGES ON WordPressBD.* TO 'Felipe'@'10.0.2.151';
CREATE USER 'Felipe'@'10.0.2.153' IDENTIFIED BY 'password'; 

GRANT ALL PRIVILEGES ON WordPressBD.* TO 'Felipe'@'10.0.2.153';
  

FLUSH PRIVILEGES;

 EXIT;


#Aqui cambiaremos la ip que viene por la nuestro servidor de BBDD
sudo cat /etc/mysql/mysql.conf.d/mysqld.cnf|sed "s/^bind-address[[:space:]]*=.*/bind-address = 10.0.3.92/" > /etc/mysql/mysql.conf.d/mysqld.cnf

#Reiniciamos el servicio de mysql

sudo systemctl restart mysql




