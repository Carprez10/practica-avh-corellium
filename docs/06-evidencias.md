# 6. Evidencias técnicas del proceso

**Criterio de la rúbrica:** presentar evidencias claras, ordenadas y
verificables como capturas, comandos, registros, URLs y resultados de
ejecución (11.11%).

## 6.1 Convención de nombres

Todas las evidencias viven en `evidencias/`. Se usa un prefijo numérico que
coincide con el criterio de la rúbrica:

```text
evidencias/
├── 01-cuenta-arm.png
├── 01b-acceso-avh.png
├── 02-demo-corellium.png
├── 02b-dispositivo.png
├── 03-pi-encendida.png
├── 03b-consola.png
├── 03c-uname.png
├── 03d-os-release.png
├── 03e-red.png
├── 04-gist-ejecucion.png
├── 04b-asdf.png
├── 04c-otp-build.png
├── 04d-jit.png
├── 04e-rebar3.png
├── 04f-crypto.png
├── 05-opencode.png
├── 05b-diagnostico.png
├── 06-logs.png
├── logs/
│   └── aplicar_gist.log
└── texto/
    ├── 03-uname.txt
    ├── 03-os-release.txt
    ├── 03-nproc.txt
    ├── 03-free.txt
    ├── 03-df.txt
    ├── 04-otp.txt
    ├── 04-jit.txt
    └── 04-rebar3.txt
```

## 6.2 Lista de evidencias

| # | Evidencia | Archivo | Estado |
|---|---|---|---|
| 1 | Cuenta ARM verificada | `evidencias/01-cuenta-arm.png` | ⬜ Pendiente |
| 2 | Acceso a AVH por SSO | `evidencias/01b-acceso-avh.png` | ⬜ Pendiente |
| 3 | Trial de 30 días | `evidencias/02-demo-corellium.png` | ⬜ Pendiente |
| 4 | Dispositivo Raspberry Pi 5 | `evidencias/02b-dispositivo.png` | ⬜ Pendiente |
| 5 | Pi encendida en AVH | `evidencias/03-pi-encendida.png` | ⬜ Pendiente |
| 6 | Consola de la Pi | `evidencias/03b-consola.png` | ⬜ Pendiente |
| 7 | `uname`, `nproc`, `free` | `evidencias/03c-uname.png` | ⬜ Pendiente |
| 8 | Versión de Debian | `evidencias/03d-os-release.png` | ⬜ Pendiente |
| 9 | Red funcionando | `evidencias/03e-red.png` | ⬜ Pendiente |
| 10 | Aplicación del GIST | `evidencias/04-gist-ejecucion.png` | ⬜ Pendiente |
| 11 | asdf y plugin erlang | `evidencias/04b-asdf.png` | ⬜ Pendiente |
| 12 | Compilación de OTP | `evidencias/04c-otp-build.png` | ⬜ Pendiente |
| 13 | Verificación de JIT | `evidencias/04d-jit.png` | ⬜ Pendiente |
| 14 | rebar3 y hello_erlang | `evidencias/04e-rebar3.png` | ⬜ Pendiente |
| 15 | Crypto AES | `evidencias/04f-crypto.png` | ⬜ Pendiente |
| 16 | Sesión de OpenCode | `evidencias/05-opencode.png` | ⬜ Pendiente |
| 17 | Diagnóstico del 404 | `evidencias/05b-diagnostico.png` | ⬜ Pendiente |
| 18 | Log completo | `evidencias/logs/aplicar_gist.log` | ⬜ Pendiente |
| 19 | Resumen del script | `evidencias/texto/04-resumen-gist.txt` | ✅ Listo |

## 6.3 Cómo generar las salidas de texto

En la consola de la Pi, dentro del repositorio:

```bash
mkdir -p evidencias/texto

uname -a                  | tee evidencias/texto/03-uname.txt
cat /etc/os-release       | tee evidencias/texto/03-os-release.txt
nproc                     | tee evidencias/texto/03-nproc.txt
free -h                   | tee evidencias/texto/03-free.txt
df -h                     | tee evidencias/texto/03-df.txt
ip address                | tee evidencias/texto/03-ip.txt

erl -noshell -eval '
  io:format("OTP: ~s~n", [erlang:system_info(otp_release)]),
  io:format("ERTS: ~s~n", [erlang:system_info(version)]),
  io:format("Flavor: ~p~n", [erlang:system_info(emu_flavor)]),
  io:format("Arch: ~s~n", [erlang:system_info(system_architecture)]),
  io:format("Schedulers: ~p~n", [erlang:system_info(schedulers_online)]),
  halt().' | tee evidencias/texto/04-otp.txt

rebar3 --version          | tee evidencias/texto/04-rebar3.txt
```

## 6.4 Cómo tomar capturas útiles

1. **Captura completa de la ventana**, no solo un fragmento.
2. Incluye la barra de URL cuando sea relevante (cuenta ARM, AVH).
3. Incluye el prompt `pi@raspberrypi` y el comando ejecutado, no solo la
   salida. Así se demuestra que el resultado es de la Pi virtual.
4. Si la salida es larga (compilación de OTP), captura el inicio y el final,
   y adjunta el log completo.
5. Recorta o difumina correo, identificadores de cuenta, tokens y cookies.
6. Usa PNG para capturas y TXT para salidas de terminal.

## 6.5 Cómo copiar las capturas al repositorio

Desde la máquina local, con las capturas descargadas:

```bash
cd /ruta/al/repositorio/practica-avh-corellium
cp ~/Descargas/cuenta-arm.png        evidencias/01-cuenta-arm.png
cp ~/Descargas/demo-corellium.png    evidencias/02-demo-corellium.png
# ...
git add evidencias
git commit -m "Evidencias de la práctica AVH"
git push
```

Si se trabaja desde la Pi, se pueden subir con la pestaña **Files** de AVH o
por SCP, y luego hacer `git add`/`commit`/`push` desde la Pi (con una llave o
token configurado fuera del repositorio).

## 6.6 Evidencias que no deben publicarse

- Correo completo sin difuminar.
- Contraseñas o frases de recuperación.
- Tokens de GitHub, Arm o Corellium.
- Cookies de sesión.
- Llaves privadas SSH.
- Identificadores de cuenta o facturación.

Si una captura contiene alguno de esos datos, se edita antes de hacer `git
add`. Ver [08-seguridad.md](08-seguridad.md).

## 6.7 Estado de las evidencias

Al finalizar la práctica, esta sección debe quedar así:

> Todas las evidencias de la tabla están adjuntas en `evidencias/` y los
> resultados coinciden con las tablas de [04-aplicacion-gist.md](04-aplicacion-gist.md).

## 6.8 Lista de verificación

- [ ] Carpeta `evidencias/` creada.
- [ ] Capturas con nombres de la tabla.
- [ ] Salidas de texto en `evidencias/texto/`.
- [ ] Log completo en `evidencias/logs/`.
- [ ] Datos sensibles ocultos.
- [ ] Enlaces del README verificados.
