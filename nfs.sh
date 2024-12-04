Instalar NFS:
sudo apt update
sudo apt upgrade
sudo apt install nfs-kernel-server -y


#Actualizamos y instalamos apache
sudo apt update && sudo apt install -y apache2

Exportar el directorio compartido:


sudo nano /etc/exports


var/www/html 10.0.1.153(rw,sync,no_root_squash) 10.0.1.151(rw,sync,no_root_squash)


Reiniciamos el servicio NFS
sudo exportfs -ar
sudo systemctl restart nfs-kernel-server



sudo apt install wget -y
wget https://wordpress.org/latest.zip

ls
sudo apt install unzip -y

mv latest.zip /var/www/html

cd /var/www/html

unzip latest.zip