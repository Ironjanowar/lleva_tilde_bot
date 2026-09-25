# Despliegue en Coco

El bot se ejecuta como un servicio `systemd --user` y guarda su caché y estadísticas en SQLite.

## Rutas

- Código: `/home/cuwano/apps/lleva_tilde_bot`
- Release: `/home/cuwano/apps/lleva_tilde_bot/_build/prod/rel/lleva_tilde_bot`
- SQLite: `/home/cuwano/.local/share/lleva_tilde_bot/lleva_tilde_bot.db`
- Variables privadas: `/home/cuwano/.config/lleva_tilde_bot/env`
- Unidad: `/home/cuwano/.config/systemd/user/lleva-tilde-bot.service`

El archivo de variables debe tener permisos `600` y este formato. `DATABASE_PATH` debe permanecer dentro de `/home/cuwano/.local/share/lleva_tilde_bot`, que es la ruta habilitada para escritura por la unidad:

```dotenv
BOT_TOKEN=...
DATABASE_PATH=/home/cuwano/.local/share/lleva_tilde_bot/lleva_tilde_bot.db
```

## Compilación y migraciones

Con las versiones de `.tool-versions` instaladas mediante mise:

```bash
umask 077
export MIX_ENV=prod
set -a
. "$HOME/.config/lleva_tilde_bot/env"
set +a

install -d -m 700 "$(dirname "$DATABASE_PATH")"
mise exec -- mix deps.get
mise exec -- mix compile
mise exec -- mix ecto.create
chmod 600 "$DATABASE_PATH"
mise exec -- mix ecto.migrate
mise exec -- mix release --overwrite
```

## Instalación de la unidad

```bash
install -m 644 deploy/lleva-tilde-bot.service "$HOME/.config/systemd/user/"
systemctl --user daemon-reload
systemctl --user enable lleva-tilde-bot.service
systemctl --user restart lleva-tilde-bot.service
systemctl --user is-active lleva-tilde-bot.service
```

El usuario `cuwano` debe tener *lingering* habilitado para que el servicio arranque sin una sesión interactiva.

## Operación

```bash
systemctl --user status lleva-tilde-bot.service
systemctl --user restart lleva-tilde-bot.service
journalctl --user-unit lleva-tilde-bot.service -f
```

Antes de sustituir una instalación PostgreSQL existente, conserva su dump. Reinicia el bot y verifica que la base SQLite contiene las tablas y que responde a una palabra. Solo entonces retira el servicio antiguo:

```bash
systemctl --user disable --now lleva-tilde-postgres.service
rm "$HOME/.config/systemd/user/lleva-tilde-postgres.service"
systemctl --user daemon-reload
```
