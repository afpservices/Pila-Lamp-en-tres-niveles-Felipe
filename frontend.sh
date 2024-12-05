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