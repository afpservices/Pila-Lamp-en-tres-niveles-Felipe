#!/bin/bash
# Aprovisionamiento de los Servidores Backend

# Actualiza y agrega repositorios necesarios
sudo apt update && sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update

# Instala PHP  y los módulos necesarios
sudo apt install php libapache2-mod-php php-mysql php-curl php-gd php-xml php-mbstring php-xmlrpc php-zip php-soap php-intl -y


# Instala Apache, MySQL y NFS
sudo apt install -y apache2 php-mysql nfs-common

# Crea directorio y monta NFS
sudo mkdir -p /var/www/html/wordpress
sudo mount -t nfs nfs-server:/export/wordpress /var/www/html/wordpress

# Descarga y extrae WordPress
wget -q https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
tar -xzf /tmp/wordpress.tar.gz -C /var/www/html/wordpress
