# Simulador CSP — Asignación de tareas mediante backtracking

Simulador interactivo para explorar paso a paso la resolución de un CSP (problema de satisfacción de restricciones) con backtracking y reducción de dominios.

## Descripción

Tres empleados (**Ana, Luis, Carlos**) deben repartirse tres tareas (**T1, T2, T3**), una por persona y sin repetir.

| Persona | Tareas permitidas |
|---------|-------------------|
| Ana     | T1, T2            |
| Luis    | T1, T3            |
| Carlos  | T2, T3            |

Orden de búsqueda: variables **Ana → Luis → Carlos**, valores **T1 → T2 → T3** (solo los que estén en el dominio vigente).

El simulador muestra, paso a paso:
- Variable seleccionada y valor que se está probando
- Dominios antes y después de cada asignación (valores eliminados / restaurados resaltados)
- Restricciones satisfechas o incumplidas en cada paso
- Ramas descartadas y el motivo
- Retrocesos (backtracking)
- Soluciones completas y número total
- Árbol de búsqueda y grafo de restricciones
- Interruptor para activar o desactivar la restricción extra **Carlos ≠ T3** y comparar el efecto

## Resultado clave

- **Sin restricción extra:** 2 soluciones
  - Ana=T1, Luis=T3, Carlos=T2
  - Ana=T2, Luis=T1, Carlos=T3
- **Con Carlos ≠ T3:** 1 solución (Ana=T1, Luis=T3, Carlos=T2). La rama Ana=T2 se descarta de inmediato porque el dominio de Carlos queda vacío.

## Contenido del repo

- `index.html` — la aplicación completa (HTML + CSS + JS en un solo archivo).
- `Dockerfile` — imagen nginx que sirve la app.
- `docker-compose.yml` — levanta el contenedor con un solo comando.
- `README.md` — esta guía.

No hay backend, base de datos, dependencias externas ni paso de build.

## Ejecutar en local

Basta con abrir `index.html` en el navegador. Si se prefiere servirlo por HTTP:

```bash
python3 -m http.server 8080
```

y abrir `http://localhost:8080`.

## Arquitectura

Todo el código está en `index.html`, dentro de la etiqueta `<script>`:

| Función | Descripción |
|---------|-------------|
| `build(extra)` | Ejecuta el backtracking con reducción de dominios y devuelve la traza de eventos, los nodos del árbol y las soluciones |
| `layout(nodes)` | Calcula la posición de cada nodo del árbol |
| `replay(state, step)` | Reconstruye asignación, dominios, registro y soluciones hasta un paso dado |
| `render*` | Pintan dominios, descripción del paso, árbol, registro, soluciones y grafo de restricciones |

El algoritmo se ejecuta completo al cargar (o al activar/desactivar Carlos ≠ T3) y la interfaz reproduce la traza paso a paso, lo que permite avanzar y retroceder sin recalcular.

## Desplegar

### GitHub Pages (recomendado)
1. En el repo: **Settings → Pages**.
2. En "Source" elegir **Deploy from a branch**.
3. Branch: la rama principal del repo (`main` o `master`), carpeta `/ (root)`. **Save**.
4. En 1-2 minutos aparece el enlace público: `https://<usuario>.github.io/<repo>/`.

### Netlify Drop
Arrastrar `index.html` a **app.netlify.com/drop** y se obtiene un enlace público al instante.

### Docker (servidor limpio)
No hace falta instalar nada en el servidor aparte de Docker. La imagen usa `nginx:alpine` y solo contiene el `index.html`.

Con Docker Compose:

```bash
git clone <url-del-repo>
cd <repo>
docker compose up -d --build
```

Queda disponible en `http://<ip-del-servidor>:8080`. Para cambiar el puerto, editar `8080:80` en `docker-compose.yml`.

Sin Compose:

```bash
docker build -t simulador-csp .
docker run -d --name simulador-csp -p 8080:80 --restart unless-stopped simulador-csp
```

Detener y borrar (deja el servidor limpio):

```bash
docker compose down            # con Compose
# o bien
docker rm -f simulador-csp && docker rmi simulador-csp
```

Para actualizar tras un `git pull`: `docker compose up -d --build`.

### Servidor propio sin Docker (on-premise)
Al ser un archivo estático, sirve cualquier servidor web:

```bash
git clone <url-del-repo>
cd <repo>
python3 -m http.server 8080
```

Para algo permanente, copiar `index.html` a la carpeta pública de Nginx o Apache (por ejemplo `/var/www/simulador-csp/`) y apuntar el `root` a ella.

## Actualizar

Reemplazar `index.html`, hacer commit y push. GitHub Pages y Netlify se actualizan solos; en servidor propio hay que volver a copiar el archivo (o hacer `git pull`).
