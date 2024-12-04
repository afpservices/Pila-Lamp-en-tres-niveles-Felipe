#!/bin/bash

# Aprovisionamiento del Balanceador de Carga

#Actualizamos y instalamos apache
sudo apt update && sudo apt install -y apache2

#habilitamos el proxy y el soporte para HTTPS y certificado SSL
sudo a2enmod proxy proxy_http ssl

#Ahora le diremos que escuche por el puerto https y le indicaremos los datos necesarios

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

sudo systemctl restart apache2