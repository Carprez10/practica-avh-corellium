# 8. Seguridad, ética y manejo de credenciales

**Criterio de la rúbrica:** gestionar cuentas, accesos y credenciales de forma
segura, ética y responsable, sin exponer información sensible (11.11%).

## 8.1 Principios aplicados

1. **Cuenta personal e intransferible.** La cuenta de ARM y el trial de AVH son
   personales. No se comparten credenciales ni se crean cuentas duplicadas para
   extender el trial.
2. **Contraseña única y administrador de contraseñas.** No se reutiliza la
   contraseña de ARM en otros servicios.
3. **MFA.** Se recomienda activar autenticación en dos pasos en la cuenta ARM.
4. **SSO.** Se usa “Sign in with Arm” en AVH en lugar de crear credenciales
   locales adicionales.
5. **Mínimo privilegio.** Los comandos de instalación usan `sudo` solo cuando
   es necesario; el trabajo de Erlang y rebar3 se hace como usuario `pi`.
6. **Datos sensibles fuera del repositorio.** El repositorio es público, así
   que no contiene correos completos, tokens, cookies ni llaves.

## 8.2 Qué no se publica

| Dato | Riesgo | Medida |
|---|---|---|
| Correo completo | Spam, phishing | Recortar o difuminar en capturas |
| Contraseña de ARM | Toma de cuenta | Nunca se escribe en el repo |
| Token de GitHub | Acceso al código | Se usa `gh auth` o un token guardado fuera del repo |
| Cookies de sesión | Suplantación | No se capturan |
| Llave privada SSH | Acceso a la Pi | Solo se comparte la llave pública |
| ID de cuenta/facturación | Ingeniería social | Difuminar |
| Código de recuperación | Toma de cuenta | Guardar en gestor de contraseñas |

## 8.3 Contraseña de la Raspberry Pi virtual

La imagen de AVH usa `pi` / `raspberry`, que es pública y conocida. En una
instancia real se cambia de inmediato:

```bash
passwd
```

En esta práctica la instancia es efímera y se apaga al terminar, pero aun así:

- No se reutiliza `raspberry` en otros servicios.
- No se expone la nueva contraseña en capturas.
- No se comparte la instancia con terceros.

## 8.4 Llaves SSH

Si se usa SSH para conectarse a la Pi:

```bash
ssh-keygen -t ed25519 -C "avh-practica"
```

- La llave **privada** (`~/.ssh/id_ed25519`) nunca se sube al repositorio.
- La llave **pública** (`.pub`) es la que se registra en AVH.
- No se usa `ssh-copy-id` con contraseñas dentro de scripts.

## 8.5 Repositorio público

Antes de cada `git push`:

```bash
git status
git diff --cached
```

Y se revisa que no haya:

- Archivos `.env`, `.pem`, `.key`, `id_rsa`, `id_ed25519`.
- Tokens en scripts o notebooks.
- Capturas con datos personales.
- Logs con rutas que revelen información privada.

El `.gitignore` del repositorio excluye, entre otros:

```text
.env
*.pem
*.key
id_rsa
id_ed25519
_build/
```

## 8.6 Ética con el trial

- El trial es para evaluación, no para uso comercial.
- No se automatiza la creación de cuentas para obtener trials adicionales.
- No se comparte el acceso con compañeros: cada estudiante debe tener su
  propia cuenta.
- Si el trial expira, se documenta y se consulta al profesor; no se intenta
  evadir la limitación.
- La instancia se apaga al terminar para no consumir recursos innecesarios.

## 8.7 Evidencia

| Evidencia | Archivo | Estado |
|---|---|---|
| Capturas revisadas | `evidencias/04d-jit.png`, `03f-free-swap.png`, `03g-swap.png` | ✅ Sin datos personales |
| `.gitignore` | `.gitignore` | ✅ Reglas de exclusión versionadas |
| Token o contraseña | — | ➖ No se capturaron, por diseño |

> **Nota:** no existe una captura de “datos difuminados” porque las tres
> capturas incluidas son de consola y no contienen correo, tokens ni
> identificadores de cuenta. La revisión se hizo antes de publicarlas.

## 8.8 Reflexión breve

La seguridad no fue un paso final, sino una decisión transversal. El hecho de
publicar el repositorio obligó a revisar cada captura antes de subirla. También
fue importante entender que el trial tiene valor económico y que apagar la
instancia es parte de un uso responsable, no solo de un ahorro personal.

## 8.9 Lista de verificación

- [ ] Cuenta ARM con contraseña única (no verificable desde el repo).
- [ ] MFA activado (no verificado).
- [ ] Contraseña de la Pi cambiada (no verificado).
- [x] Sin tokens ni llaves privadas en el repo.
- [x] Capturas revisadas (sin datos personales).
- [x] Instancia apagada al terminar.
- [x] Trial usado de forma ética.
