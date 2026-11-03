# 2. Activación de la demo de Corellium Virtual Hardware

**Criterio de la rúbrica:** activación de la demo de 30 días de Corellium
Virtual Hardware (11.11%).

## 2.1 Qué es Corellium Virtual Hardware

Corellium es una plataforma de virtualización de dispositivos basada en
**CHARM™**, un hipervisor tipo 1 diseñado para ejecutar modelos de dispositivos
ARM sobre servidores ARM. En lugar de emular instrucciones con software,
Corellium ejecuta el sistema operativo del dispositivo virtual sobre la misma
arquitectura, lo que permite obtener un comportamiento muy cercano al hardware
real.

Arm Virtual Hardware (AVH) utiliza esa tecnología para ofrecer dispositivos
virtuales como la **Raspberry Pi 5**. Para el desarrollador, la ventaja es
poder trabajar sin comprar ni mantener hardware físico, con instancias
reproducibles y reiniciables.

## 2.2 Condiciones del trial

Según la documentación oficial de AVH:

| Condición | Valor |
|---|---|
| Duración | 30 días desde el registro en AVH |
| Core-hours incluidos | 100 |
| Núcleos activos simultáneos | Hasta 15 |
| Slots de dispositivos | 25 |
| Costo después del trial | $0.50 USD por core-hour |

La Raspberry Pi 5 virtual usa **4 núcleos**. Por eso, si se deja encendida:

```text
100 core-hours / 4 núcleos = 25 horas de reloj
```

Es decir, el trial alcanza para unas **25 horas reales** con la Pi encendida.
Apagar la instancia cuando no se usa es parte de la buena gestión del recurso.

## 2.3 Cómo verificar que la demo está activa

1. Entrar a <https://app.avh.corellium.com>.
2. Iniciar sesión con **Sign in with Arm**.
3. Revisar el panel principal:
   - Si aparece la lista de dispositivos y la opción **CREATE DEVICE**, el
     acceso está operativo.
   - Si aparece un aviso de **Trial**, revisar los días restantes y el consumo
     de core-hours.
4. Abrir la sección de **Subscription**, **Billing** o **Account** (el nombre
   exacto puede variar según la versión de AVH) y localizar:
   - Estado del trial.
   - Fecha de expiración.
   - Core-hours consumidos y disponibles.
5. Si el trial no aparece activo, volver a <https://www.arm.com/account>,
   verificar la cuenta y entrar de nuevo por SSO. El trial se activa
   automáticamente al registrarse en AVH.

> **Nota:** no se debe crear una segunda cuenta para “reiniciar” el trial. Eso
> va contra las condiciones del servicio y no es ético. Si el trial expiró, se
> documenta la situación y se consulta al profesor o al soporte.

## 2.4 Evidencia

| Evidencia | Archivo | Qué debe verse |
|---|---|---|
| Panel de AVH con el trial | `evidencias/02-demo-corellium.png` | Estado del trial, días restantes o core-hours |
| Dispositivo Raspberry Pi 5 creado | `evidencias/02b-dispositivo.png` | Lista de dispositivos con la Pi 5 |
| Consumo o suscripción | `evidencias/02c-consumo.png` | Core-hours usados/disponibles |

> 📷 **Pendiente de captura.** Si no aparece la palabra “Trial”, sirve una
> captura del panel con la cuenta activa y la posibilidad de crear dispositivos,
> más otra de la sección de suscripción.

## 2.5 Apagado responsable

Al terminar cada sesión:

1. Usar el botón de **apagado** del dispositivo en AVH.
2. Esperar a que el estado cambie a **off**.
3. Verificar en el panel que no quedó encendido.
4. Cerrar el navegador (cerrar la pestaña no apaga la instancia).

También se puede apagar desde la consola:

```bash
sudo poweroff
```

Pero la verificación válida es la del panel de AVH.

## 2.6 Reflexión breve

El trial no es “gratis sin consecuencias”: consume core-hours mientras el
dispositivo está activo, incluso en pausa. Entender esa métrica cambió la forma
de trabajar: se planearon las sesiones, se apagó la Pi al terminar y se evitó
dejarla encendida mientras se redactaba la documentación.

## 2.7 Lista de verificación

- [ ] Trial de 30 días localizado en el panel.
- [ ] Core-hours y días restantes documentados.
- [ ] Dispositivo Raspberry Pi 5 visible.
- [ ] Capturas obtenidas.
- [ ] Instancia apagada al finalizar.
