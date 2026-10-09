# Publicar Repuestómetro en tu VPS

Cada vez que se actualiza la rama `main` y los tests pasan, GitHub Actions construye la app, la guarda en GitHub Packages (`ghcr.io/benjafudai/repuestometro`) y la levanta en tu VPS con [Kamal](https://kamal-deploy.org), la herramienta de despliegue de Rails 8. No hay que instalar nada en tu computador.

En el VPS quedan tres contenedores Docker:

| Contenedor | Qué hace |
|---|---|
| `repuestometro-web-…` | La app. También corre la actualización diaria de precios (6:00, hora de Chile). |
| `repuestometro-db` | PostgreSQL 16. Sus datos quedan en `~/repuestometro-db/data` del VPS y no se expone a internet. |
| `kamal-proxy` | Recibe el tráfico en los puertos 80 y 443, saca el certificado SSL gratis (Let's Encrypt) y cambia de versión sin cortar el servicio. |

La configuración está en `config/deploy.yml` y `.github/workflows/deploy.yml`. Los datos privados (IP, claves) no van en el repositorio: se guardan en GitHub.

## Lo que necesitas

- Un VPS con Ubuntu o Debian, con acceso SSH y los puertos 80 y 443 libres, o una IP adicional si otra app ya los usa (ver [Si GestFleet está en el mismo VPS](#si-gestfleet-está-en-el-mismo-vps)). Repuestómetro necesita del orden de 1 GB de RAM libre para la app, sus tareas y PostgreSQL.
- Opcional: un dominio o un subdominio de uno que ya tengas (por ejemplo `repuestometro.tudominio.cl`). Sin dominio la app queda en `http://IP-DEL-VPS`, sin candado SSL.

## 1. Preparar el VPS

Si entras al VPS como `root`, no hay que instalar nada: Kamal instala Docker la primera vez.

Si entras con otro usuario, instala Docker y dale permiso a ese usuario:

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
```

Si el VPS tiene firewall, abre SSH, HTTP y HTTPS:

```bash
sudo ufw allow 22/tcp && sudo ufw allow 80/tcp && sudo ufw allow 443/tcp
```

## 2. Crear una llave SSH para GitHub

GitHub necesita su propia llave para entrar al VPS. En tu computador (en Windows sirve PowerShell):

```bash
ssh-keygen -t ed25519 -f repuestometro_deploy -N "" -C "github-repuestometro"
```

Eso crea dos archivos: `repuestometro_deploy` (privada, va a GitHub) y `repuestometro_deploy.pub` (pública, va al VPS). Agrega la pública al VPS, cambiando `root@IP-DEL-VPS` por tu usuario e IP:

```bash
# Windows (PowerShell)
type repuestometro_deploy.pub | ssh root@IP-DEL-VPS "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

# Mac o Linux
ssh-copy-id -i repuestometro_deploy.pub root@IP-DEL-VPS
```

## 3. Apuntar el dominio o subdominio

En el panel de tu dominio (NIC Chile, Cloudflare, etc.) crea un registro **A** apuntando a la IP que usará Repuestómetro. Para un subdominio del dominio de GestFleet, el nombre del registro es `repuestometro` y la dirección queda `repuestometro.tudominio.cl`; el sitio de GestFleet no cambia. Si usas Cloudflare, déjalo en «DNS only» (nube gris) para que el certificado SSL se pueda emitir.

## 4. Guardar los datos en GitHub

En el repositorio, entra a **Settings → Secrets and variables → Actions**.

En la pestaña **Variables** crea:

| Nombre | Valor |
|---|---|
| `VPS_HOST` | La IP del VPS, por ejemplo `203.0.113.10` |
| `VPS_USER` | El usuario SSH. Si es `root` puedes omitirla. |
| `APP_DOMAIN` | El dominio o subdominio, por ejemplo `repuestometro.tudominio.cl`. Omítela si no tienes dominio. |
| `APP_IP` | La IP que usará solo Repuestómetro, cuando el VPS tiene otra IP para GestFleet. Omítela si Repuestómetro es lo único que usa los puertos 80 y 443. |

En la pestaña **Secrets** crea:

| Nombre | Valor |
|---|---|
| `VPS_SSH_KEY` | Todo el contenido del archivo `repuestometro_deploy` (la llave privada), incluidas las líneas `-----BEGIN…` y `-----END…`. |
| `SECRET_KEY_BASE` | Una clave larga al azar. Genérala en el VPS con `openssl rand -hex 64`. |
| `REPUESTOMETRO_DATABASE_PASSWORD` | La contraseña de la base de datos. Genérala en el VPS con `openssl rand -hex 24`. |

No cambies `REPUESTOMETRO_DATABASE_PASSWORD` después del primer despliegue: PostgreSQL guarda la contraseña con la que se creó.

Mientras `VPS_HOST` no exista, el despliegue automático se salta sin dar error.

## 5. Primer despliegue

En GitHub entra a **Actions → Deploy → Run workflow** y elige `main`. Al terminar, abre `https://tu-dominio` (o `http://IP-DEL-VPS` si no tienes dominio).

La primera descarga de precios de las tiendas parte sola en segundo plano después del primer arranque. Desde ahí se repite todos los días a las 6:00.

Después de esto no hay que hacer nada más: cada cambio que llegue a `main` se publica solo cuando pasan los tests.

## Tareas comunes en el VPS

```bash
# Ver la app y la base de datos
docker ps --filter name=repuestometro

# Ver los logs de la app en vivo
docker logs -f $(docker ps -q --filter label=service=repuestometro --filter label=role=web)

# Actualizar los precios ahora
docker exec $(docker ps -q --filter label=service=repuestometro --filter label=role=web) bin/rails prices:update

# Consola de Rails
docker exec -it $(docker ps -q --filter label=service=repuestometro --filter label=role=web) bin/rails console

# Respaldo de la base de datos
docker exec repuestometro-db pg_dump -U repuestometro repuestometro_production > respaldo-$(date +%F).sql
```

## Si GestFleet está en el mismo VPS

Las dos apps pueden vivir en el mismo VPS. Lo único que no se comparte son los puertos 80 y 443 de una misma IP, porque solo un programa puede escucharlos. Con dos IPs se reparte así:

| | GestFleet | Repuestómetro |
|---|---|---|
| IP | IP 1 | IP 2 (`APP_IP`) |
| Dirección | `tudominio.cl` | `repuestometro.tudominio.cl` (`APP_DOMAIN`) |
| Base de datos | La suya | Contenedor `repuestometro-db`, sin puertos abiertos |

1. Revisa que el VPS tenga las dos IPs activas: `ip -4 addr` debe mostrar ambas. Algunos proveedores entregan la IP adicional pero hay que agregarla a mano en la red del VPS; su ayuda lo explica como «IP adicional» o «additional IP».
2. Revisa quién usa los puertos 80 y 443: `sudo ss -tlnp | grep -E ':(80|443) '`.
   - Si aparece `0.0.0.0:80` o `*:80`, GestFleet (Nginx, Apache, etc.) escucha en todas las IPs y hay que dejarlo solo en la IP 1. En Nginx se cambia `listen 80;` por `listen IP-1:80;` y `listen 443 ssl;` por `listen IP-1:443 ssl;` en cada sitio, y se recarga con `sudo nginx -t && sudo systemctl reload nginx`.
   - Si aparece `IP-1:80`, ya está listo.
   - Si no aparece nada, los puertos están libres.
3. Define `APP_IP` con la IP 2 y `APP_DOMAIN` con el subdominio (paso 4).

Si algún día GestFleet también se publica con Kamal (está en su roadmap), las dos apps comparten el mismo `kamal-proxy`, que atiende a cada una por su dominio. En ese caso se quita `APP_IP`.

Para separar Repuestómetro en otro servidor más adelante, basta con cambiar `VPS_HOST` y `APP_IP` y apuntar el subdominio a la nueva IP. La base de datos se lleva con el respaldo de arriba.

## Problemas comunes

| Error | Causa |
|---|---|
| `Permission denied (publickey)` | La llave pública no está en `~/.ssh/authorized_keys` del usuario `VPS_USER`, o `VPS_SSH_KEY` no tiene la llave privada completa. |
| `Docker is not installed … can't be automatically installed` | El usuario no es `root`. Instala Docker como en el paso 1. |
| `port is already allocated` / `address already in use` | Otro programa usa el puerto 80 o 443 en esa IP. Ver la sección de GestFleet. |
| `cannot assign requested address` | La IP de `APP_IP` no está activa en el VPS. Ver el paso 1 de la sección de GestFleet. |
| La página abre sin candado o el certificado falla | El dominio todavía no apunta a la IP del VPS, el puerto 80 está cerrado, o Cloudflare está en modo proxy (nube naranja). |
| `target failed to become healthy` | La app no arrancó. Revisa los logs del contenedor `repuestometro-web-…` con `docker logs`. |
