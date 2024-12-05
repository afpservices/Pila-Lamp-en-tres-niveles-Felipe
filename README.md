# Despliegue de WordPress en AWS con Arquitectura de Tres Capas

## Índice
1. [Introducción](#introducción)
2. [Configuración y Desarrollo de la Infraestructura](#configuración-y-desarrollo-de-la-infraestructura)
   - [Creación de Subredes](#creación-de-subredes)
   - [Puerta de Enlace para la Pública](#puerta-de-enlace-para-la-pública)
   - [Creación de NAT Gateway para la Privada](#creación-de-nat-gateway-para-la-privada)
   - [Creación de Tablas de Enrutamiento](#creación-de-tablas-de-enrutamiento)
3. [Lanzamiento de Instancias y Grupos de Seguridad](#lanzamiento-de-instancias-y-grupos-de-seguridad)
   - [Configuración del Balanceador de Carga](#configuración-del-balanceador-de-carga)
   - [Configuración de Frontend](#configuración-de-frontend)
   - [Configuración de NFS](#configuración-de-nfs)
   - [Configuración de la Base de Datos](#configuración-de-la-base-de-datos)
4. [Scripts de Aprovisionamiento](#scripts-de-aprovisionamiento)
   - [Balanceador](#balanceador)
   - [NFS](#nfs)
   - [Frontend](#frontend)
   - [Base de Datos](#base-de-datos)
5. [Pruebas y Resultados](#pruebas-y-resultados)

---

## Introducción

Vamos a desplegar WordPress en AWS utilizando una arquitectura de tres capas:
- **Capa 1 (Pública):** Un balanceador de carga que gestionará el tráfico hacia los servidores web.
- **Capa 2 (Privada):** Servidores Frontend que alojan WordPress.
- **Capa 3 (Privada):** Un servidor de base de datos MySQL.

Solo la capa pública tendrá acceso desde el exterior. Implementaremos grupos de seguridad que aseguren la comunicación entre capas según las necesidades. Además, usaremos un dominio público y configuraremos un certificado SSL para asegurar la conexión.

---

## Configuración y Desarrollo de la Infraestructura

### Creación de Subredes

1. **Capa Pública (Balanceador):**  
   Subred: `10.0.1.0/24`.

2. **Capa Privada (Frontend):**  
   Subred: `10.0.2.0/24`.

3. **Capa Privada (Base de Datos):**  
   Subred: `10.0.3.0/24`.

### Puerta de Enlace para la Pública

- Configuramos una puerta de enlace de Internet para la VPC. Esto permite que la capa pública tenga acceso a Internet.

### Creación de NAT Gateway para la Privada

- Creamos un NAT Gateway con una IP elástica para permitir que los servidores en las capas privadas puedan acceder a Internet.

### Creación de Tablas de Enrutamiento

1. **Tabla de Enrutamiento Pública:**
   - Asociada a la subred pública.
   - Ruta: `0.0.0.0/0` hacia la puerta de enlace de Internet.

2. **Tabla de Enrutamiento Privada:**
   - Asociada a las subredes privadas.
   - Ruta: `0.0.0.0/0` hacia el NAT Gateway.

---

## Lanzamiento de Instancias y Grupos de Seguridad

### Configuración del Balanceador de Carga

1. **Configuración de la Instancia:**
   - Seleccionamos la VPC y la subred pública.
   - Habilitamos la IP pública.
   - Asociamos un grupo de seguridad que permita HTTP, HTTPS y SSH desde cualquier lugar.

2. **Asociación de IP Elástica y Dominio:**
   - Asignamos una IP elástica y configuramos el dominio público.

### Configuración de Frontend

1. Creamos dos instancias en la subred privada correspondiente.
2. Asociamos un grupo de seguridad que permita:
   - HTTP y HTTPS desde el balanceador.
   - SSH desde el balanceador.

### Configuración de NFS

1. Configuramos el servidor NFS en una instancia de la subred privada de frontend.
2. Asociamos un grupo de seguridad que permita:
   - Tráfico NFS hacia los frontend.
   - SSH desde el balanceador.

### Configuración de la Base de Datos

1. Creamos una instancia en la subred privada correspondiente.
2. Asociamos un grupo de seguridad que permita:
   - Tráfico MySQL desde los frontend.
   - SSH desde los frontend.

---

## Scripts de Aprovisionamiento

### Balanceador

Este script instala Apache, habilita el modo de balanceo de carga y configura el certificado SSL.

```bash
#!/bin/bash
apt update && apt install -y apache2
a2enmod proxy proxy_http ssl
systemctl restart apache2

# Configuración de balanceo de carga
cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ProxyPreserveHost On
    ProxyPass / http://10.0.2.100/
    ProxyPassReverse / http://10.0.2.100/
</VirtualHost>
EOF

systemctl restart apache2
