# 7. Resolución de problemas y autonomía

**Criterio de la rúbrica:** identificar errores, consultar fuentes
pertinentes, aplicar soluciones razonadas y demostrar autonomía técnica
(11.11%).

## 7.1 Problema 1 — `apt` devuelve 404 al instalar `git`

### Síntoma

```text
Err:2 http://security.debian.org/debian-security bullseye-security/main arm64 git arm64 1:2.30.2-1+deb11u5
  404  Not Found [IP: 151.101.194.132 80]
E: Failed to fetch .../git_2.30.2-1%2bdeb11u5_arm64.deb
```

### Diagnóstico

El mensaje no era un problema de red ni de permisos. La versión exacta que
pedía `apt` ya no existía en el pool. Debian 11 (bullseye) terminó su soporte
LTS en agosto de 2026 y sus paquetes se movieron a `archive.debian.org`.

Se comprobó con:

```bash
curl -I http://security.debian.org/debian-security/pool/updates/main/g/git/git_2.30.2-1+deb11u5_arm64.deb
# HTTP/1.1 404 Not Found

curl -I http://archive.debian.org/debian-security/pool/updates/main/g/git/git_2.30.2-1+deb11u5_arm64.deb
# HTTP/1.1 200 OK
```

### Solución

Redirigir las fuentes a `archive.debian.org` y desactivar la validación de
fecha de los Releases:

```bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo sed -i \
  -e 's|https*://deb.debian.org/debian|http://archive.debian.org/debian|g' \
  -e 's|https*://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' \
  /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null || true
echo 'Acquire::Check-Valid-Until "false";' | sudo tee /etc/apt/apt.conf.d/99archive
sudo apt-get update
```

Se automatizó en `scripts/arreglar_apt_bullseye.sh`.

### Lección

Un 404 en `apt` no siempre se arregla con `apt update`. Hay que revisar si la
distribución sigue soportada y si los paquetes fueron archivados.

---

## 7.2 Problema 2 — `libwxgtk3.2-dev` no existe

### Síntoma

El GIST instala `libwxgtk3.2-dev`, pero en bullseye el paquete disponible es
`libwxgtk3.0-gtk3-dev`.

### Diagnóstico

wxWidgets 3.2 llegó a Debian 12/13. Debian 11 tiene la rama 3.0. El GIST fue
escrito para Debian 13.

### Solución

No instalar wx y compilar OTP con `--without-wx`. Esa opción es suficiente
para esta práctica porque no se usa Observer ni la GUI de Erlang.

```bash
KERL_CONFIGURE_OPTIONS="... --without-wx" asdf install erlang 27.3.4.19
```

### Lección

No todos los paquetes del GIST son necesarios. Distinguir entre dependencias
obligatorias y opcionales evita instalar software incompatible.

---

## 7.3 Problema 3 — gcc 10 frente al gcc ≥ 11 del GIST

### Síntoma

El GIST advierte que el JIT requiere gcc/g++ ≥ 11 y C++17. Debian 11 trae
gcc 10.2.1.

### Diagnóstico

El JIT de OTP 27 usa AsmJIT, que se compila como C++17. Un compilador
demasiado antiguo puede fallar al compilar `erts/emulator/.../asmjit`.

### Solución

Se intentó primero con **gcc 10.2.1**, el compilador por defecto de Debian 11.
El resultado real fue exitoso: gcc 10.2.1 compiló AsmJIT y el JIT quedó activo
(`emu_flavor = jit`). No fue necesario usar clang ni `--disable-jit`.

El script `scripts/aplicar_gist_avh.sh` dejó preparados dos respaldos por si
gcc fallaba:

1. Instalar `clang-11` y reintentar con `CC=clang-11 CXX=clang++-11`.
2. Compilar con `--disable-jit`. OTP 27 sigue funcionando, pero `emu_flavor`
   sería `emu`.

El resultado real se documenta en
[04-aplicacion-gist.md](04-aplicacion-gist.md).

### Lección

La advertencia del GIST (“gcc ≥ 11”) era conservadora: en esta instancia,
gcc 10.2.1 fue suficiente para compilar el JIT. Aun así, conviene tener un
plan B. La diferencia entre Debian 11 y Debian 13 no impidió el objetivo
principal, pero sí obligó a verificar el resultado en lugar de asumirlo.

---

## 7.4 Problema 4 — `rebar3` no está en apt

### Síntoma

```text
E: Unable to locate package rebar3
```

### Diagnóstico

Debian 11 no empaqueta `rebar3`.

### Solución

Descargar el escript oficial, como hace el GIST:

```bash
mkdir -p ~/bin
wget https://s3.amazonaws.com/rebar3/rebar3 -O ~/bin/rebar3
chmod +x ~/bin/rebar3
export PATH="$HOME/bin:$PATH"
rebar3 --version
```

### Lección

No todas las herramientas del ecosistema Erlang están en los repositorios del
sistema. Conviene conocer el canal oficial de cada herramienta.

---

## 7.5 Problema 5 — El GIST asume un CM5 físico

### Síntoma

El GIST habla de un CM5, Debian 13, kernel 6.18 y un usuario `distiller`. En
AVH no existe ese hardware ni ese usuario.

### Diagnóstico

El video del profesor usa **Arm Virtual Hardware**, que ofrece una Raspberry
Pi 5 virtual. El GIST usa un **CM5 físico**. Son entornos distintos.

### Solución

- Usar la Raspberry Pi 5 virtual de AVH.
- Adaptar los paquetes a Debian 11.
- Reemplazar `distiller` por `pi` en los ejemplos de systemd.
- Documentar que los pasos de producción no se ejecutaron literalmente.

### Lección

Un GIST “verificado en hardware real” no es una receta universal. Hay que
leerlo, entender el contexto y adaptarlo.

---

## 7.6 Problema 6 — No saber si el trial está activo

### Síntoma

No había certeza de si la demo de 30 días estaba habilitada.

### Diagnóstico

El trial se activa automáticamente al registrarse en AVH. Si se puede crear un
dispositivo y aparece la lista de dispositivos, el acceso está operativo.

### Solución

Revisar el panel de AVH y la sección de suscripción. Documentar días restantes
y core-hours. Si el trial no está activo, volver a entrar por SSO desde la
cuenta ARM verificada.

### Lección

No hace falta “activar” un botón adicional: el registro en AVH inicia el
trial. Lo importante es verificarlo y no confundir “tener cuenta” con “tener
trial vigente”.

---

## 7.7 Problema 7 — Consumo de core-hours

### Síntoma

La instancia sigue consumiendo aunque no se esté usando la pantalla.

### Diagnóstico

AVH cobra core-hours mientras el dispositivo está activo, incluso en pausa.
Una Pi de 4 núcleos consume 4 core-hours por hora de reloj.

### Solución

Apagar la instancia desde el panel al terminar cada sesión:

```bash
sudo poweroff
```

Y verificar en AVH que el estado sea `off`.

### Lección

El trial de 100 core-hours equivale a unas 25 horas reales con la Pi encendida.
Planear las sesiones es parte de la gestión del entorno.

---

## 7.8 Problema 8 — El servicio systemd usa un usuario inexistente

### Síntoma

El GIST propone un servicio con `User=distiller`, pero en AVH el usuario es
`pi`.

### Diagnóstico

El GIST asume un servidor de producción con un usuario creado previamente.

### Solución

No se instaló el servicio systemd porque no es necesario para validar el
entorno. Si se quisiera, habría que cambiar `User=pi` y ajustar las rutas del
release.

### Lección

Los pasos de producción del GIST son opcionales para esta práctica. Aplicarlos
sin adaptarlos habría generado errores de permisos.

---

## 7.9 Problema 9 — La instancia tiene 4 GB, no 8 GB

### Síntoma

`free -h` mostraba:

```text
Mem: 3.7Gi ...
```

El GIST asume un CM5 con 8 GB y la documentación inicial de AVH habla de
8 GB, pero la instancia creada tiene 4 GB.

### Diagnóstico

AVH permite distintas configuraciones de memoria. La instancia usada se creó
con 4 GB (3.7 GiB visibles). No es un error: es una variante válida.

### Solución

Compilar OTP con menos paralelismo para evitar que el enlazador agote la
memoria:

```bash
MAKEFLAGS="-j2" asdf install erlang 27.3.4.19
```

El script `aplicar_gist_avh.sh` detecta la memoria y limita `make` a 2 jobs
automáticamente cuando hay menos de 6 GB. También se puede añadir swap si el
disco lo permite.

### Lección

La memoria es un recurso crítico al compilar. Ajustar `-j` según la RAM es más
seguro que usar todos los núcleos a ciegas. Documentar la configuración real
(4 GB) es más honesto que repetir el valor del GIST (8 GB).

---

## 7.10 Resumen de autonomía

| Problema | ¿Se resolvió solo? | Fuente consultada |
|---|---|---|
| 404 de apt | Sí, con diagnóstico y prueba | Documentación de Debian + AVH |
| wxWidgets 3.2 | Sí, adaptando el GIST | Paquetes de Debian 11 |
| gcc 10 vs 11 | Sí, con respaldo documentado | Foro de Erlang + GIST |
| rebar3 ausente | Sí, descarga oficial | GIST y rebar3.org |
| CM5 vs AVH | Sí, comparación de entornos | Video y documentación de AVH |
| Trial | Sí, verificación en el panel | Documentación de AVH |
| Core-hours | Sí, apagado responsable | Documentación de AVH |
| systemd | Sí, se identificó como opcional | GIST |
| RAM de 4 GB | Sí, límite de jobs y swap opcional | `free -h` y documentación de make |

## 7.11 Lista de verificación

- [ ] Cada problema tiene síntoma, diagnóstico y solución.
- [ ] Las soluciones se probaron en la Pi.
- [ ] Se citan fuentes cuando corresponde.
- [ ] Se explica qué se aprendió.
- [ ] Se distingue entre error del entorno y error propio.
