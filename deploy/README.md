# Despliegue en Coco

El bot se ejecuta como un servicio `systemd --user` y utiliza una instancia de PostgreSQL dedicada.

## Rutas

- Código: `/home/cuwano/apps/lleva_tilde_bot`
- Release: `/home/cuwano/apps/lleva_tilde_bot/_build/prod/rel/lleva_tilde_bot`
- Datos PostgreSQL: `/home/cuwano/.local/share/lleva_tilde_bot/postgres`
- Variables privadas: `/home/cuwano/.config/lleva_tilde_bot/env`
- Unidades: `/home/cuwano/.config/systemd/user/`

El archivo de variables debe tener permisos `600` y este formato:

```dotenv
BOT_TOKEN=...
DATABASE_URL=ecto://cuwano:...@127.0.0.1:55432/lleva_tilde_bot_repo
POOL_SIZE=5
```

## Compilación y migraciones

Con las versiones de `.tool-versions` instaladas mediante mise:

```bash
export MIX_ENV=prod
set -a
. "$HOME/.config/lleva_tilde_bot/env"
set +a

mise exec -- mix deps.get
mise exec -- mix compile
mise exec -- mix ecto.migrate
mise exec -- mix release --overwrite
```

## Instalación de las unidades

```bash
install -m 644 deploy/lleva-tilde-postgres.service "$HOME/.config/systemd/user/"
install -m 644 deploy/lleva-tilde-bot.service "$HOME/.config/systemd/user/"
systemctl --user daemon-reload
systemctl --user enable --now lleva-tilde-postgres.service
systemctl --user enable --now lleva-tilde-bot.service
```

El usuario `cuwano` debe tener *lingering* habilitado para que los servicios arranquen sin una sesión interactiva.

## Operación

```bash
systemctl --user status lleva-tilde-bot.service
systemctl --user restart lleva-tilde-bot.service
journalctl --user-unit lleva-tilde-bot.service -f
```
