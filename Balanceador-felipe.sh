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