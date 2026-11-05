# Checklist de entrega

Leyenda: `[x]` completado o verificado · `[ ]` no completado / no verificable.

## 1. Registro en developer.arm.com

- [x] Cuenta creada.
- [x] Correo verificado.
- [ ] MFA activado (recomendado; no se verificó).
- [x] Acceso a AVH por SSO comprobado (se creó y usó una instancia).
- [ ] Captura `evidencias/01-cuenta-arm.png` (no disponible).
- [ ] Captura `evidencias/01b-acceso-avh.png` (no disponible).

## 2. Demo de Corellium

- [x] Trial operativo (la instancia se creó y se usó).
- [ ] Días restantes y core-hours documentados (no se registraron).
- [ ] Captura `evidencias/02-demo-corellium.png` (no disponible).
- [ ] Captura `evidencias/02b-dispositivo.png` (no disponible).
- [x] Instancia apagada al terminar.

## 3. Raspberry Pi virtual

- [x] Dispositivo Raspberry Pi 5 creado.
- [x] Firmware Raspberry Pi OS Desktop 11.2.0.
- [x] Consola accesible.
- [x] `uname -m` = `aarch64`.
- [x] `nproc` = 4.
- [x] Memoria y disco verificados (3.7 GiB de RAM y 27 GB libres).
- [x] Red verificada (clonación y descargas funcionaron).
- [x] Capturas `03f-free-swap.png` y `03g-swap.png`.
- [ ] Captura de la consola y del panel de AVH (no disponibles).

## 4. GIST del docente

- [x] Repositorios de Debian 11 corregidos.
- [x] Dependencias instaladas.
- [x] asdf v0.14.1 instalado.
- [x] Plugin erlang agregado.
- [x] OTP 27.3.4.19 compilado.
- [x] `emu_flavor` verificado (`jit`).
- [x] rebar3 instalado (3.28.0).
- [x] `hello_erlang` creado y compilado.
- [x] Crypto AES y ChaCha20 verificados.
- [x] Captura `04d-jit.png` y salidas de texto.
- [ ] Log completo (no recuperado antes de apagar la instancia).

## 5. OpenCode

- [ ] Captura de la sesión (no disponible).
- [x] Ejemplo de error resuelto (404 de `apt`).
- [x] Explicación de los límites de la herramienta.

## 6. Evidencias

- [x] Nombres claros y ordenados.
- [x] Salidas de texto en `evidencias/texto/`.
- [ ] Log en `evidencias/logs/` (no recuperado).
- [x] Datos sensibles revisados: las capturas no muestran correo ni tokens.
- [x] Alcance declarado con honestidad en `docs/06-evidencias.md`.

## 7. Resolución de problemas

- [x] 404 de apt documentado.
- [x] wxWidgets 3.2 documentado.
- [x] gcc 10 vs 11 documentado (gcc 10.2.1 compiló el JIT).
- [x] rebar3 ausente documentado.
- [x] CM5 vs AVH documentado.
- [x] Límite de RAM (4 GB) documentado.

## 8. Seguridad

- [ ] Contraseña de la Pi cambiada (no verificado).
- [x] Sin tokens ni llaves privadas en el repo.
- [x] Capturas revisadas.
- [x] Trial usado éticamente.

## 9. Documentación final

- [x] README con resultados reales.
- [x] Tablas de resultados completadas.
- [x] Reflexión técnica revisada.
- [x] Repositorio publicado.
