# 1. Registro en developer.arm.com

**Criterio de la rúbrica:** registro en developer.arm.com (11.11%).

## 1.1 Propósito de la plataforma ARM

`developer.arm.com` es el portal oficial para desarrolladores del ecosistema
ARM. No es solo un formulario de registro: concentra documentación técnica,
especificaciones de la arquitectura, herramientas de desarrollo, sistemas
operativos, firmware y acceso a productos como Arm Virtual Hardware.

En esta práctica se usó para:

- Crear una **cuenta de Arm Developer** verificada.
- Acceder a **Arm Virtual Hardware** mediante SSO.
- Consultar la documentación de la Raspberry Pi 5 virtual y de Corellium.
- Gestionar el trial de 30 días y el uso de core-hours.

La cuenta es la identidad que vincula el registro con el entorno virtual. Sin
una cuenta verificada, AVH no permite iniciar sesión por SSO.

## 1.2 Pasos realizados

1. Abrir <https://www.arm.com/account>.
2. Crear la cuenta con un correo propio y una contraseña única.
3. Verificar el correo desde el enlace enviado por ARM.
4. Activar la autenticación en dos pasos (MFA) si está disponible.
5. Iniciar sesión en <https://app.avh.corellium.com> con **Sign in with Arm**.
6. Comprobar que el nombre de la cuenta aparece en el panel de AVH.

> **Seguridad:** en este documento no se escribe el correo completo, la
> contraseña ni el identificador de la cuenta. Las capturas se publican con
> esos datos recortados o difuminados.

## 1.3 Evidencia

| Evidencia | Archivo | Estado |
|---|---|---|
| Cuenta creada y verificada | `evidencias/01-cuenta-arm.png` | ➖ No disponible |
| Acceso a AVH por SSO | `evidencias/01b-acceso-avh.png` | ➖ No disponible |
| Propósito de la plataforma | `evidencias/01c-arm-developer.png` | ➖ No disponible |

> **Nota de honestidad:** no se adjuntan capturas de la cuenta porque la
> sesión del navegador ya no estaba abierta cuando se cerró la práctica. El
> acceso quedó demostrado de forma indirecta: la instancia de AVH se creó y se
> usó durante toda la actividad. No se publica ningún dato personal de la
> cuenta.

## 1.4 Reflexión breve

El registro no fue un trámite aislado: fue la puerta de entrada a un ecosistema
completo. La cuenta de ARM es la misma identidad que habilita el trial de AVH,
por eso la verificación del correo y el uso de SSO son pasos críticos. También
fue importante entender que el trial es personal y no debe compartirse.

## 1.5 Lista de verificación

- [x] Cuenta creada en `developer.arm.com`.
- [x] Correo verificado.
- [ ] MFA (recomendado; no se verificó en esta práctica).
- [x] Acceso a AVH con SSO comprobado (se creó y usó la instancia).
- [x] Sin datos sensibles publicados.
- [ ] Capturas de la cuenta (no disponibles).
