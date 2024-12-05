# Despliegue de WordPress en AWS con Arquitectura de Tres Capas

## Índice
1. [Introducción](#introducción)
2. [Configuración y Desarrollo de la Infraestructura](#configuración-y-desarrollo-de-la-infraestructura)
   - [Creación de Subredes](#creación-de-subredes)
   - [Creación de NAT Gateway para la Privada](#creación-de-nat-gateway-para-la-privada)
   - [Creación de Tablas de Enrutamiento](#creación-de-tablas-de-enrutamiento)
3. [Lanzamiento de Instancias y Grupos de Seguridad](#Lanzamiento-de-Instancias-y-asociacion-de-grupos-de-seguridad-a-las-instancias)
   - [Configuración del Balanceador de Carga](#configuración-del-balanceador-de-carga)
   - [Configuración de Frontend](#configuración-de-frontend)
   - [Configuración de NFS](#configuración-de-nfs)
   - [Configuración de la Base de Datos](#configuración-de-la-base-de-datos)
4. [Scripts de Aprovisionamiento](#scripts-de-aprovisionamiento)
   - [Balanceador](#APROVISIONAMIENTO-EN-BALANCEADOR)
   - [NFS](#APROVISIONAMIENTO-DE-NFS)
   - [Frontend](#APROVISIONAMIENTO-EN-FRONTEND(2-servidores-frontend))
   - [Base de Datos](#APROVISIONAMIENTO-BASE-DE-DATOS)
5. [Resultados](#RESULTADOS)



## Introducción

Vamos a desplegar WordPress en AWS utilizando una arquitectura de tres capas:
- **Capa 1 (Pública):** Un balanceador de carga que gestionará el tráfico hacia los servidores web.
- **Capa 2 (Privada):** Servidores Frontend que alojan WordPress.
- **Capa 3 (Privada):** Un servidor de base de datos MySQL.

- Para ello vamos a realizar el despliegue de wordpress en aws el cual vamos a utilizar y crear una arquitectura en 3 - capas la cual contará con una sola capa publica en la capa1 y en la capa 2 y 3 (Frontend y BBDD) contara con una --- capa privada en el cual solo tendremos acceso desde el exterior a la capa publica.

- Además impediremos la conectividad entre la capa1 y la capa 3 ademas de preparar los grupos de seguridad para cada --Maquina que vamos a utilizar en cada capa para poder desplegar wordpress en AWS




## Configuración y Desarrollo de la Infraestructura

- Para ello vamos a crear una VPC el cual le he asignado una ip de red, en mi caso la 10.0.0.0/16
![unnamed](https://github.com/user-attachments/assets/cbbc60b5-1ec7-4d62-a080-625ce02fea5e)


### Creación de Subredes

-siempre deberemos fijarnos en que el bloque CIDR IPV4 sea la ip de la red que hemos creado anteriormente en la VPC
1. **Capa Pública (Balanceador):**  
   SubredBalanceador: `10.0.1.0/24`.

   ![unnamed](https://github.com/user-attachments/assets/30ae9f22-4bb5-456d-aeaa-87454e24141a)


3. **Capa Privada (Frontend):**  
   Subred: `10.0.2.0/24`.

   ![unnamed](https://github.com/user-attachments/assets/ae7fc9df-ebee-46cd-ad46-35c646e8c3e9)


5. **Capa Privada (Base de Datos):**  
   Subred: `10.0.3.0/24`.
   
![unnamed](https://github.com/user-attachments/assets/4f273155-88da-444d-90db-917adbe9e939)


### CREACION DE PUERTA DE ENLACE PARA LA PUBLICA

- Para ello he creado una puerta de enlace la cual irá asociada a la VPC que hemos creado, esta la creo para que la Pública tenga acceso a internet desde el exterior

  ![unnamed](https://github.com/user-attachments/assets/95b47e86-c5f4-4d0a-bf59-3b571199409c)


### Creación de NAT Gateway para la Privada

- Para ello voy a crear una NAT GATEWAY para que los equipos que esten en la privada tengan acceso a internet la cual crearemos una ip elastica que nos sale ya al crearla y deberemos de asociarla a la VPC que hemos creado y a la subred del balanceador.
  
![unnamed](https://github.com/user-attachments/assets/382f4c85-bad1-4861-82f3-2ba03f9b5a47)

### Creación de Tablas de Enrutamiento

- Para ello crearemos dos tablas de enrutamiento, una publica y otra privada en el cual deberemos de asociarla a la VPC que hemos creado anteriormente.


1. **Tabla de Enrutamiento Pública:**
   - Asociada a la subred pública.
   - Ruta: `0.0.0.0/0` hacia la puerta de enlace de Internet.
     
![unnamed](https://github.com/user-attachments/assets/012fe42c-3850-46c9-9bdf-3bd3b583b484)

2. **Tabla de Enrutamiento Privada:**
   - Asociada a las subredes privadas.
   - Ruta: `0.0.0.0/0` hacia el NAT Gateway.
  
![unnamed](https://github.com/user-attachments/assets/a3be2519-a0c5-472e-b3ea-fc0d8824e1e7)



## Lanzamiento de Instancias y asociacion de grupos de seguridad a las instancias



### Configuración del Balanceador de Carga

- Para ello he lanzado una instancia el cual le he creado un par de claves las cuales utilizaremos para esta practica  
![unnamed](https://github.com/user-attachments/assets/d20d0646-4ada-4a7c-9673-20c073dedba1)

- Ademas deberemos de seleccionar la VPC que hemos creado anteriormente ademas de seleccionar la subred del balanceador la cual es la publica y deberemos de habilitar la pestaña de Habilitar la direccion ip publica 


1. **Configuración de la Instancia:**
   - Seleccionamos la VPC y la subred pública y Habilitamos la IP pública.
   - 
    ![unnamed](https://github.com/user-attachments/assets/f62caf36-e573-44e6-bb69-9a341e8072ab)

   - Asociamos un grupo de seguridad que permita HTTP, HTTPS y SSH desde cualquier lugar.
     
     ![unnamed](https://github.com/user-attachments/assets/27603366-df99-4107-9eb7-ab315b79eb07)


2. **Asociación de IP Elástica y Dominio:**
   - Despues le he asignado la ip elastica y la he incluido en el dominio.
     
![unnamed](https://github.com/user-attachments/assets/3c006aaa-f0df-4395-b45b-d695a438fd80)

![unnamed](https://github.com/user-attachments/assets/bcf72fb4-a9d0-42e5-a1f4-e6e16582b2a5)


### Configuración de servidores de Frontend (Puse backend al principio y para no hacer un lio quede el nombre como backend)


1. Para ello deberemos de seleccionar la misma VPC y seleccionamos la subred que hemos creado para los frontend y he creado los 2 frontend.
 
![unnamed](https://github.com/user-attachments/assets/dabe65b8-355f-4b37-b15b-7a1fe13a3da6)

2. Asociamos un grupo de seguridad que permita:
   - HTTP y HTTPS desde el balanceador y SSH desde el balanceador.
     
![unnamed](https://github.com/user-attachments/assets/27298f8b-b4d8-42ac-ab30-59d985d14651)

### Configuración de NFS

1. Configuramos el servidor NFS en una instancia de la subred privada de frontend.

![unnamed](https://github.com/user-attachments/assets/7eed4a18-11f1-477b-99c1-778aa6aac09e)

2. Asociamos un grupo de seguridad que permita:
   - Tráfico NFS hacia los frontend y SSH desde el balanceador.
   - 
![unnamed](https://github.com/user-attachments/assets/fbf5629b-c876-4a0f-b17e-010a5e4ebbbb)


### Configuración de la Base de Datos

1. Creamos una instancia en la subred privada correspondiente.

 ![unnamed](https://github.com/user-attachments/assets/8464820c-0b73-41eb-ad43-bae248426f0e)

2. Asociamos un grupo de seguridad que permita:
   - Tráfico MySQL desde los frontend y SSH desde los frontend.
![unnamed](https://github.com/user-attachments/assets/5bed8f5e-63ba-46c7-b25e-bdeca7fc4e5d)

## Scripts de Aprovisionamiento

### APROVISIONAMIENTO EN BALANCEADOR 

- En este script de aprovisionamiento en el que hemos instalado apache y hemos habilitado el modo de carga de balanceo proxy y hemos comprobado primero que nos funciona correctamente apache en el dominio y después hemos creado y habilitado el archivo de configuración necesario para que funcione el balanceo de carga, ademas de instalar el certificado SSL


```bash
#!/bin/bash

# Aprovisionamiento del Balanceador de Carga

#Actualizamos y instalamos apache
sudo apt update && sudo apt install -y apache2

#habilitamos el proxy y el soporte para HTTPS y certificado SSL
sudo a2enmod proxy proxy_http ssl

#habilitaremos todos los modulos necesarios para activar el balanceador de carga 
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod lbmethod_byrequests

sudo systemctl restart apache2

#Ahora le diremos que escuche por el puerto https con el certificado SSL y le indicaremos los datos necesarios, esto es para comprobar que nos funciona todo correctamente con el dominio

cat <<EOL | sudo tee /etc/apache2/sites-available/000-default.conf
<VirtualHost *:443>
 ServerName felipe.hopto.org
 SSLEngine on
 SSLCertificateFile /etc/ssl/certs/tucert.pem
 SSLCertificateKeyFile /etc/ssl/private/tucert.key
 ProxyPass / http://felipe.hopto.org/
 ProxyPassReverse / http://felipe.hopto.org/
</VirtualHost>
EOL
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/tucert.key \
-out /etc/ssl/certs/tucert.pem

#Una vez hemos comprobado que se ha realizado correctamente la anterior configuracion, creamos el siguiente archivo de configuracion el cual hace que balancee en los 2 servidores frontend

sudo nano /etc/apache2/sites-available/Balanceador.conf

#<VirtualHost *:80>
#ServerName 54.224.51.110
#        <Proxy balancer://mycluster>
#        
#                BalancerMember http://10.0.2.153
#          
#                BalancerMember http://10.0.2.151
#        </Proxy>
#ProxyPass / balancer://mycluster/
#</VirtualHost>

#ahora procederemos a deshabilitar el sitio por defecto y habilitaremos la nueva configuracion
sudo a2dissite 000-default.conf
sudo a2enssite Balanceador.conf

sudo systemctl restart apache2

```
- Aqui procedo a configurar el certificado SSL con los correspondientes datos 

![unnamed](https://github.com/user-attachments/assets/53301d11-216c-48a6-b3e0-291780357db4)

## Conexion via SSH 

- Para poder conectarme por SSH he de importar el archivo wordpress.perm que he crado antes con las claves y asi puedo conectarme por SSH a las demas maquinas ya que debo de hacerlo para poder tener acceso.

-   ![unnamed](https://github.com/user-attachments/assets/5c76e677-113f-4e0a-951b-e2965cfd0d9e)

- Ademas aplicaremos estos permisos

![unnamed](https://github.com/user-attachments/assets/81485f40-2e07-4f49-a71b-45395cf10961)

### APROVISIONAMIENTO DE NFS 

- En este script de aprovisionamiento procederemos a instalar NFS server para que actue como servidor NFS y que pueda compartir el directorio con los frontend, ademas de instalar wordpress y descomprimirlo

  
```bash
#Instalar NFS:
sudo apt update
sudo apt upgrade
sudo apt install nfs-kernel-server -y


#Procederemos a crear la carpeta que nos indican los apuntes,la cual voy a utilizar para poder exportar mi directorio compartido con los frontend 

sudo mkdir -P /var/nfs/general


#aqui deberemos de cambiar el propietario de la carpeta para poder realizar cualquier cambio sobre esa carpeta o cualquier configuracion

sudo chown nobody:nogroup /var/nfs/general

#Aqui procederemos a añadir los dos servidores fontend como clientes del servidor NFS y los añadimos al directorio /etc/exports


echo "/var/nfs/general    10.0.2.151(rw,sync,no_subtree_check)" >> /etc/exports
echo "/var/nfs/general    10.0.2.151(rw,sync,no_subtree_check)" >> /etc/exports


#Reiniciamos el servicio NFS

sudo systemctl restart nfs-kernel-server


#procederemos a instalar wordpress en el servidor NFS 

sudo apt install wget -y

sudo wget https://wordpress.org/latest.zip 

sudo mv wordpress.org /var/nfs/general/

#Descomprimimos el wordpress en el directorio /var/nfs/general/

sudo apt install unzip -y

cd /var/nfs/general/

sudo unzip latest.zip

sudo chown -R www-data:www-data /var/nfs/general/wordpress

```

### APROVISIONAMIENTO EN FRONTEND(2 servidores frontend)

- Este es el script que he utilizado para los frontend el cual he automontado ya la carpeta de NFS, ademas de instalar apache y modificar y habilitar el archivo de configuracion necesario:

```bash
#!/bin/bash
# Aprovisionamiento de los Servidores Backend

# Actualiza y agrega repositorios necesarios
sudo apt update && sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update

# Instalamos PHP  y los módulos necesarios
sudo apt install php libapache2-mod-php php-mysql php-curl php-gd php-xml php-mbstring php-xmlrpc php-zip php-soap php-intl -y


# Instalamos Apache, MySQL y NFS
sudo apt install -y apache2 php-mysql nfs-common

# Crea directorio y monta NFS
sudo mkdir -p /nfs/general
echo "10.0.2.125:/var/nfs/general    /nfs/general   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab

#Aqui procedera a crear el archivo de configuracion de wordpress  
sudo nano /etc/apache2/sites-available/wordpress.conf

#en el fichero creado anteriormente insertamos la siguiente informacion la cual tenemos disponible en los apuntes:

<VirtualHost *:80>

#        ServerAdmin webmaster@localhost
#        DocumentRoot /nfs/general/wordpress/
#        <Directory /nfs/general/wordpress>
#           Options +FollowSymlinks
#           AllowOverride All
#           Require all granted
#        </Directory>

#        ErrorLog ${APACHE_LOG_DIR}/error.log
#        CustomLog ${APACHE_LOG_DIR}/access.log combined

# </VirtualHost>

#Procedemos a deshabilitar el 000-default.conf y procedemos a habilitar el fichero de configuracion que hemos creado anteriromente 

sudo a2dissite 000-default.conf
sudo a2enssite wordpress.conf

#Reinicia el servicio apache 

sudo systemctl restart apache2.service

```

### APROVISIONAMIENTO BASE DE DATOS


```bash
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

```


- Una vez ya tenemos el archivo del bind address configurado procederemos a probar,pero antes de nada nos iremos al servidor NFS y configuraremos el archivo wp-config.php tal que así para que no se nos vuelva a desmontar el wordpress


![unnamed](https://github.com/user-attachments/assets/a567505c-bda8-49e6-b11d-93fd1cc47bac)

### RESULTADOS

- Una vez hecho esto procederemos a conectarnos mediante la ip o el dominio con la direccion que aparece y procederemos a insertar los datos de la base de datos que hemos creado anteriormente y comprobamos


![image](https://github.com/user-attachments/assets/c4bb2638-d79c-47a3-addf-b2177c37c5ef)

- Comprobacion de la conexion con la BD

![unnamed](https://github.com/user-attachments/assets/1f6c4c99-4b36-4dc9-addc-7e5c615f3c91)

![unnamed](https://github.com/user-attachments/assets/d56e6e2f-de2d-4257-ae11-33777faa0257)


- Observamos que todo funciona correctamente


