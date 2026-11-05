# 9. Documentación final y reflexión técnica

**Criterio de la rúbrica:** documentación completa con pasos, resultados,
dificultades, soluciones y reflexión sobre ARM, virtualización y Corellium
(11.11%).

## 9.1 Qué se hizo

Se instaló y validó una Raspberry Pi 5 virtual en Arm Virtual Hardware, se
activó el trial de Corellium y se aplicó el GIST del docente para dejar un
entorno de Erlang/OTP 27 con rebar3. El proceso incluyó:

- Registro y verificación de la cuenta ARM.
- Acceso a AVH por SSO.
- Creación del dispositivo Raspberry Pi 5.
- Verificación de arquitectura, núcleos, memoria, disco y red.
- Corrección de los repositorios de Debian 11.
- Instalación de asdf y compilación de OTP 27.
- Instalación de rebar3.
- Creación y compilación del proyecto `hello_erlang`.
- Verificación de JIT, schedulers y crypto.
- Documentación de evidencias y problemas.

## 9.2 Sobre ARM

ARM no es solo una marca de procesadores: es una arquitectura con un modelo de
licencias y un ecosistema de herramientas. La Raspberry Pi 5 usa núcleos
**Cortex-A76** de 64 bits (aarch64), con extensiones para criptografía y
operaciones vectoriales. Esa arquitectura es la misma familia que el CM5, lo
que permite que el código compilado para uno funcione en el otro con pocos
ajustes.

La diferencia práctica apareció en el sistema operativo: el CM5 del GIST usa
Debian 13, mientras que la imagen de AVH es Debian 11. La arquitectura era la
correcta, pero el userspace era más antiguo. Eso demuestra que “ser aarch64” no
garantiza que cualquier instrucción funcione: importan la versión del
compilador, las bibliotecas y los paquetes.

## 9.3 Sobre virtualización y Corellium

Corellium usa **CHARM**, un hipervisor tipo 1 que ejecuta dispositivos ARM
sobre servidores ARM. No es un emulador de instrucciones: el sistema operativo
invitado corre sobre la misma arquitectura, lo que reduce la traducción y
permite un comportamiento más realista.

Ventajas observadas:

- **Reproducibilidad:** la instancia se crea desde una imagen conocida.
- **Disponibilidad:** no se depende de hardware físico ni de envíos.
- **Rapidez de reinicio:** si algo se rompe, se puede volver a empezar.
- **Acceso remoto:** se trabaja desde el navegador, sin monitor ni cables.
- **Aislamiento:** los experimentos no afectan una máquina personal.

Limitaciones observadas:

- **Imagen fija:** AVH ofrece Raspberry Pi OS 11.2.0, no Debian 13.
- **No es un CM5 exacto:** la placa virtual es una Pi 5; el CM5 tiene otro
  factor de forma y otro firmware.
- **Trial limitado:** 100 core-hours equivalen a unas 25 horas con 4 núcleos.
- **Latencia:** la consola remota puede sentirse menos fluida que una máquina
  local.
- **Persistencia:** si el trial expira, la instancia se apaga y los datos
  pueden perderse.

Aun así, para esta práctica la virtualización fue una ventaja: permitió
equivocarse, corregir y documentar sin consecuencias sobre hardware real.

## 9.4 Sobre Debian 11 y la reproducibilidad

El problema del 404 fue la lección técnica más importante. Un entorno que
“funcionaba ayer” puede dejar de funcionar cuando una distribución pasa a
estado archivado. La solución no fue un parche cosmético, sino entender el
ciclo de vida de Debian:

- Debian 11 pasó a LTS y luego a archivo.
- Los paquetes se movieron a `archive.debian.org`.
- Los índices de apt conservaron versiones que ya no estaban en el pool.
- Fue necesario desactivar `Check-Valid-Until` porque los Releases del archivo
  ya no tienen fecha de validez vigente.

La reproducibilidad exige fijar versiones y documentar las fuentes. En un
entorno educativo, conviene que el GIST indique explícitamente la versión de
la imagen y las adaptaciones para Debian 11.

## 9.5 Sobre Erlang/OTP y el JIT en ARM64

OTP 27 incorpora un JIT estable para ARM64 basado en AsmJIT. El JIT compila las
instrucciones BEAM a código nativo en tiempo de carga, lo que mejora el
rendimiento frente al intérprete. La verificación se hace con:

```erlang
erlang:system_info(emu_flavor).
```

Si devuelve `jit`, el JIT está activo; si devuelve `emu`, se está usando el
intérprete.

En esta práctica, la compilación de OTP fue la parte más costosa. No solo por
el tiempo, sino porque el compilador de Debian 11 (gcc 10) es más antiguo que
el que recomienda el GIST (gcc ≥ 11). Esa diferencia obligó a prever un
respaldo sin JIT y a documentar el resultado real.

También fue interesante comprobar que los schedulers de BEAM se ajustan a los
núcleos disponibles. En una Pi de 4 núcleos, `+S 4:4` tiene sentido; poner más
schedulers no acelera el sistema, solo agrega contención.

## 9.6 Sobre el uso de OpenCode

OpenCode ayudó a interpretar el GIST, detectar la causa del 404, adaptar los
paquetes y redactar la documentación. Su mayor valor fue explicar el “por qué”
de los errores, no solo dar comandos.

Pero también quedó claro su límite: no puede ver la pantalla de AVH, no puede
tomar capturas y no puede verificar por sí solo que un comando funcionó. Esa
verificación sigue siendo responsabilidad del estudiante. Usar bien la
herramienta significa contrastar sus propuestas con la realidad y documentar
las diferencias.

## 9.7 Qué haría distinto

1. **Fijar la imagen desde el inicio.** Anotar la versión exacta de Raspberry
   Pi OS y Debian antes de instalar nada.
2. **Reservar tiempo para la compilación de OTP.** En AVH puede tardar entre
   30 y 90 minutos; conviene lanzarla y hacer otras tareas mientras tanto.
3. **Capturar evidencias durante el proceso, no al final.** Es fácil olvidar
   una pantalla o un comando. En esta entrega solo se conservaron tres
   capturas de consola; las del panel web y el log completo se perdieron al
   apagar la instancia. Esa experiencia justifica la recomendación.
4. **Probar primero el respaldo sin JIT.** Así se garantiza un entorno
   funcional aunque el JIT falle.
5. **Documentar las decisiones, no solo los comandos.** El valor está en
   entender por qué se adaptó cada paso.

## 9.8 Conclusión

La práctica cumplió su objetivo: se instaló una Raspberry Pi virtual funcional
en AVH, se activó el trial de Corellium, se aplicó el GIST del docente con las
adaptaciones necesarias y se documentó todo con evidencias verificables.

El aprendizaje principal es que **virtualizar no elimina las diferencias**:
cambia el hardware por software, pero el sistema operativo, el compilador y las
versiones siguen importando. Adaptar el GIST a Debian 11 fue un ejercicio de
interpretación técnica, no de copiar y pegar.

El entorno quedó listo para futuras prácticas de Erlang/OTP en ARM64, con la
ventaja de poder repetir la instalación desde cero y la responsabilidad de
apagar la instancia para cuidar el trial.
