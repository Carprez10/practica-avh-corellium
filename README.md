# Práctica: instalación de Raspberry Pi virtual en Arm Virtual Hardware

**Estudiante:** [Nombre del estudiante]
**Cuenta de GitHub:** Carprez10
**Fecha:** 2 de noviembre de 2026
**Repositorio:** <https://github.com/Carprez10/practica-avh-corellium>

---

## Resumen

Esta práctica documenta la instalación, configuración y validación de una
**Raspberry Pi 5 virtual** en **Arm Virtual Hardware (AVH)**, el registro en
**developer.arm.com**, la activación de la demo de **Corellium Virtual
Hardware** y la aplicación del **GIST del docente** para instalar
**Erlang/OTP 27 con JIT** sobre la máquina virtual.

> **Nota importante:** esta actividad es independiente de la práctica de los
> diez problemas de Erlang/OTP. Aquel proyecto se conserva en otro repositorio
> y **no forma parte de esta entrega**. Aquí lo que se evalúa es el proceso de
> instalación del entorno, la aplicación del GIST y la documentación técnica.

El entorno final quedó funcionando sobre:

| Elemento | Valor |
|---|---|
| Plataforma | Arm Virtual Hardware (Corellium) |
| Dispositivo | Raspberry Pi 5 virtual, 4 núcleos, 4 GB RAM (3.7 GiB visibles) |
| Sistema operativo | Raspberry Pi OS Desktop 11.2.0 (Debian 11 bullseye) |
| Arquitectura | aarch64 |
| Erlang/OTP | 27.3.4.19 |
| JIT | `emu_flavor = jit` (ver sección de resultados) |
| rebar3 | 3.x |
| Proyecto de validación | `hello_erlang` generado con `rebar3 new release` |

---

## Índice de la documentación

1. [Registro en developer.arm.com](docs/01-cuenta-arm.md)
2. [Activación de la demo de Corellium](docs/02-demo-corellium.md)
3. [Instalación de la Raspberry Pi virtual](docs/03-instalacion-pi.md)
4. [Aplicación del GIST del docente](docs/04-aplicacion-gist.md)
5. [Uso de OpenCode como acompañamiento](docs/05-opencode.md)
6. [Evidencias técnicas](docs/06-evidencias.md)
7. [Resolución de problemas y autonomía](docs/07-resolucion-problemas.md)
8. [Seguridad, ética y manejo de credenciales](docs/08-seguridad.md)
9. [Reflexión técnica final](docs/09-reflexion.md)

---

## Mapa de la rúbrica

| Criterio | Peso | Dónde se demuestra |
|---|---:|---|
| Instalación de Raspberry Pi virtual | 11.11% | [03-instalacion-pi.md](docs/03-instalacion-pi.md) |
| Registro en developer.arm.com | 11.11% | [01-cuenta-arm.md](docs/01-cuenta-arm.md) |
| Activación de demo de Corellium | 11.11% | [02-demo-corellium.md](docs/02-demo-corellium.md) |
| Aplicación del GIST del docente | 11.11% | [04-aplicacion-gist.md](docs/04-aplicacion-gist.md) |
| Uso de OpenCode | 11.11% | [05-opencode.md](docs/05-opencode.md) |
| Evidencias técnicas | 11.11% | [06-evidencias.md](docs/06-evidencias.md) |
| Resolución de problemas y autonomía | 11.11% | [07-resolucion-problemas.md](docs/07-resolucion-problemas.md) |
| Seguridad y credenciales | 11.11% | [08-seguridad.md](docs/08-seguridad.md) |
| Documentación y reflexión | 11.11% | [09-reflexion.md](docs/09-reflexion.md) |

---

## Resultados de la validación

| Verificación | Comando | Resultado esperado | Resultado obtenido |
|---|---|---|---|
| Arquitectura | `uname -m` | `aarch64` | `aarch64` |
| Núcleos | `nproc` | `4` | `4` |
| RAM | `free -h` | ~4 GB (3.7 GiB) | 3.7 GiB + 2.1 GiB swap |
| Sistema | `cat /etc/os-release` | Debian 11 (bullseye) | Debian GNU/Linux 11 (bullseye) |
| Kernel | `uname -r` | 5.10 | `5.10.92-v8+` |
| OTP | `erl -noshell -eval '...'` | 27 | 27 (ERTS 15.2.7.14) |
| JIT | `erlang:system_info(emu_flavor)` | `jit` | **`jit`** |
| rebar3 | `rebar3 --version` | 3.x | 3.28.0 on Erlang/OTP 27 Erts 15.2.7.14 |
| Proyecto | `rebar3 compile` | `Build successful` | Compilación exitosa |

Las capturas y salidas completas están en [docs/06-evidencias.md](docs/06-evidencias.md).

---

## Cómo reproducir la instalación

Requisitos: una cuenta ARM verificada, acceso a AVH y una Raspberry Pi 5
virtual encendida con Raspberry Pi OS Desktop 11.2.0.

```bash
# 1. Clonar este repositorio en la Pi virtual
git clone https://github.com/Carprez10/practica-avh-corellium.git
cd practica-avh-corellium

# 2. Aplicar el GIST adaptado a Debian 11
chmod +x scripts/aplicar_gist_avh.sh
./scripts/aplicar_gist_avh.sh
```

El script:

1. Corrige los repositorios de Debian 11, que ya están en `archive.debian.org`.
2. Instala las dependencias de compilación adaptadas a bullseye.
3. Instala `asdf` v0.14.1 y el plugin de Erlang.
4. Compila OTP 27.3.4.19 con JIT (con respaldo sin JIT si el compilador no coopera).
5. Instala `rebar3`.
6. Crea y compila el proyecto `hello_erlang`.
7. Verifica OTP, JIT, arquitectura, schedulers y crypto AES.

Al final imprime un resumen y guarda el log en
`~/aplicar_gist_avh_<fecha>.log`.

---

## Dificultades principales y soluciones

| Dificultad | Causa | Solución |
|---|---|---|
| `404 Not Found` al instalar `git` o `erlang-nox` | Debian 11 terminó su soporte y los paquetes se movieron a `archive.debian.org` | Redirigir las fuentes y desactivar `Check-Valid-Until` |
| `libwxgtk3.2-dev` no existe | bullseye tiene wxWidgets 3.0, no 3.2 | Omitir wx y compilar con `--without-wx` |
| `rebar3` no está en apt | Debian 11 no empaqueta rebar3 | Descargarlo desde el sitio oficial |
| El GIST pide gcc ≥ 11 | bullseye trae gcc 10.2 | Intentar JIT; si falla, usar clang o `--disable-jit` y documentarlo |
| El GIST apunta a un CM5 físico | AVH ofrece Raspberry Pi 5 virtual | Adaptar comandos y documentar la diferencia |

El detalle completo está en [docs/07-resolucion-problemas.md](docs/07-resolucion-problemas.md).

---

## Seguridad

- No se publican correos completos, tokens, cookies, contraseñas ni llaves SSH.
- Las capturas con datos personales se recortan o difuminan.
- La contraseña por defecto de la imagen (`pi` / `raspberry`) se cambió y no se
  reutiliza en otros servicios.
- La instancia de AVH se apaga al terminar para no consumir core-hours.

Ver [docs/08-seguridad.md](docs/08-seguridad.md).

---

## Conclusión

La práctica permitió comprobar que AVH es una alternativa viable a un CM5
físico para desarrollar con Erlang/OTP, aunque con diferencias importantes:
la imagen disponible es Debian 11, no Debian 13, y el compilador es más
antiguo que el que pide el GIST. La adaptación razonada de esos detalles fue
parte central del ejercicio.

**Resultado clave:** OTP 27.3.4.19 compiló correctamente y el **JIT quedó
activo** (`emu_flavor = jit`) en la Raspberry Pi 5 virtual, con 4 schedulers y
crypto AES por hardware.

Ver la reflexión completa en [docs/09-reflexion.md](docs/09-reflexion.md).
