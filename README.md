# acelerometro

Demo Flutter Web que usa el acelerometro del dispositivo para mover una bola en pantalla.

En web, abre la pagina desde HTTPS y toca `Activar sensor` para que el navegador pida permiso de movimiento. Si el navegador no entrega eventos de movimiento, la bola tambien se puede mover arrastrandola en el area de juego.

## Desarrollo local

```bash
flutter pub get
flutter run -d chrome
```

## Build web

```bash
flutter build web --release --base-href /
```

La salida queda en `build/web`.

## Despliegue en Netlify

Este proyecto ya incluye `netlify.toml` y `scripts/netlify-build.sh`.

Configuracion esperada en Netlify:

- Build command: `bash scripts/netlify-build.sh`
- Publish directory: `build/web`

El script instala Flutter estable en el entorno de Netlify cuando no esta disponible, descarga dependencias y genera el build web de produccion.
