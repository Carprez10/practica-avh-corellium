# 5. Uso de OpenCode como acompañamiento del entorno

**Criterio de la rúbrica:** utilizar OpenCode de forma efectiva para
comprender, acompañar, ajustar y documentar el entorno (11.11%).

## 5.1 Papel de OpenCode en la práctica

OpenCode se usó como **asistente técnico de acompañamiento**, no como un
sustituto de la ejecución real. Su aporte se concentró en cuatro tareas:

1. **Interpretar** el GIST del docente y el video de AVH.
2. **Comparar** el entorno del GIST (CM5 físico, Debian 13) con el entorno
   real (Raspberry Pi 5 virtual, Debian 11).
3. **Escribir y revisar** los scripts de instalación y diagnóstico.
4. **Documentar** el proceso, las evidencias y la reflexión técnica.

Todas las decisiones técnicas se validaron ejecutando los comandos en la
Raspberry Pi virtual. OpenCode no tuvo acceso directo a la instancia de AVH;
por eso el flujo fue: OpenCode propone → el estudiante ejecuta → se pega la
salida → OpenCode corrige y documenta.

## 5.2 Preguntas y prompts representativos

Estos son los tipos de solicitudes que se usaron durante la práctica:

- “¿Qué diferencias hay entre el GIST del profesor y lo que ofrece AVH?”
- “El `apt install` devuelve `404 Not Found` para `git`; ¿por qué y cómo se
  arregla?”
- “Adapta el GIST a Debian 11 sin romper la instalación.”
- “Escribe un script que instale asdf, OTP 27 y rebar3, y que verifique el JIT.”
- “¿Cómo demuestro en la documentación que apliqué el GIST?”
- “Arma la estructura de evidencias según esta rúbrica.”

## 5.3 Aportes concretos

| Aporte | Resultado |
|---|---|
| Análisis del GIST | Se identificó que apunta a un CM5 con Debian 13, no a AVH |
| Diagnóstico del 404 | Se detectó que Debian 11 está en `archive.debian.org` |
| Adaptación de paquetes | Se cambió `libwxgtk3.2-dev` por compilación `--without-wx` |
| Script de instalación | `scripts/aplicar_gist_avh.sh` con respaldo sin JIT |
| Diagnóstico de compilador | Se documentó la diferencia entre gcc 10 y gcc ≥ 11 |
| Documentación | Informe organizado por los nueve criterios de la rúbrica |

## 5.4 Ejemplo de razonamiento asistido

El error inicial fue:

```text
Err:1 http://security.debian.org/debian-security bullseye-security/main arm64 git-man 1:2.30.2-1+deb11u5
  404  Not Found
```

OpenCode no se limitó a decir “ejecuta `apt update`”. Analizó que:

- La versión `1:2.30.2-1+deb11u5` ya no estaba en el pool.
- Debian 11 había terminado su soporte LTS en agosto de 2026.
- Los paquetes se habían movido a `archive.debian.org`.
- Había que desactivar `Check-Valid-Until` porque los Releases del archivo ya
  no tienen fecha de validez vigente.

La solución se probó y se convirtió en el script
`scripts/arreglar_apt_bullseye.sh`.

## 5.5 Lo que OpenCode no hizo

- No creó la cuenta de ARM ni activó el trial: eso lo hizo el estudiante.
- No tomó las capturas de pantalla.
- No ejecutó comandos dentro de AVH.
- No inventó resultados: las tablas de resultados se completan con la salida
  real de la Pi.

Reconocer esos límites fue parte del uso responsable de la herramienta.

## 5.6 Evidencia

| Evidencia | Archivo | Estado |
|---|---|---|
| Sesión de OpenCode | `evidencias/05-opencode.png` | ➖ No disponible |
| Diagnóstico del 404 | `evidencias/05b-diagnostico.png` | ➖ Documentado en `07` |
| Script generado | `evidencias/05c-script.png` | ✅ Ver `scripts/aplicar_gist_avh.sh` |

> **Nota de honestidad:** no se adjunta captura de la sesión de OpenCode. El
> resultado del trabajo sí es verificable en el repositorio: el script
> `scripts/aplicar_gist_avh.sh`, la documentación de los errores y los
> resultados reales de la Pi.

## 5.7 Reflexión breve

OpenCode fue útil sobre todo para **acelerar el diagnóstico** y **ordenar la
documentación**. La parte más valiosa no fue escribir comandos, sino explicar
por qué fallaban y proponer alternativas. Aun así, la verificación siguió
siendo humana: cada comando se ejecutó en la Pi y cada resultado se contrastó
con la salida real.

## 5.8 Lista de verificación

- [ ] Captura de la sesión de OpenCode (no disponible).
- [x] Ejemplo de un error resuelto con ayuda de OpenCode (404 de `apt`).
- [x] Explicación de los límites de la herramienta.
- [x] Relación entre las sugerencias y los comandos ejecutados.
