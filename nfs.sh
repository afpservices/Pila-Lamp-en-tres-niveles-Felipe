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