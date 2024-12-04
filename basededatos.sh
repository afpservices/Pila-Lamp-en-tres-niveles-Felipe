apt install mysql-server -y


sudo mysql

 CREATE DATABASE WordPressBD DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;



CREATE USER 'Felipe'@'10.0.2.151' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON WordPressBD.* TO 'Felipe'@'10.0.2.151';

CREATE USER 'Felipe'@'10.0.2.153' IDENTIFIED BY 'password'; 

GRANT ALL PRIVILEGES ON WordPressBD.* TO 'Felipe'@'10.0.2.153';
  

FLUSH PRIVILEGES;

 EXIT;




GRANT ALL ON WordPressBD.* TO ' UsuarioWordPress '@'localhost' IDENTIFIED BY 'NuevaContraseña';




