# Evidencias

Aquí están las capturas y salidas de texto que se pudieron conservar de la
práctica.

## Reglas

1. Usar los nombres exactos de la tabla de
   [`docs/06-evidencias.md`](../docs/06-evidencias.md).
2. No publicar correos completos, tokens, cookies, contraseñas ni llaves
   privadas.
3. Las capturas deben incluir el comando ejecutado y el prompt
   `pi@raspberrypi` cuando sea posible.
4. Las salidas largas van en `texto/`, no en una sola captura ilegible.
5. No inventar evidencias: si algo no se capturó, se declara como no
   disponible.

## Estructura real

```text
evidencias/
├── 03f-free-swap.png
├── 03g-swap.png
├── 04d-jit.png
├── README.md
└── texto/
    ├── 04-crypto.txt
    ├── 04-erl-version.txt
    ├── 04-gcc.txt
    ├── 04-rebar3-compile.txt
    ├── 04-rebar3-version.txt
    └── 04-resumen-gist.txt
```

## Alcance

- **Capturas:** tres, todas de la consola de la Raspberry Pi 5 virtual.
- **Texto:** seis salidas que demuestran OTP 27, JIT, rebar3, gcc, crypto y la
  compilación de `hello_erlang`.
- **No disponible:** capturas del panel web de AVH, captura de OpenCode y el
  log completo. La instancia se apagó antes de recuperarlos.

El detalle y la justificación están en
[`docs/06-evidencias.md`](../docs/06-evidencias.md).
