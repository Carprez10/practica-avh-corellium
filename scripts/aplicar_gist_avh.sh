#!/usr/bin/env bash
# =============================================================================
# aplicar_gist_avh.sh
#
# Aplica el GIST del docente (Erlang/OTP 27 + asdf + rebar3) en una
# Raspberry Pi 5 virtual de Arm Virtual Hardware (Debian 11 bullseye).
#
# GIST original:
#   https://gist.github.com/IoTeacher/3c3607e48bce473de9bfa6d400dec6ff
#
# Uso:
#   chmod +x scripts/aplicar_gist_avh.sh
#   ./scripts/aplicar_gist_avh.sh
#
# Variables opcionales:
#   MODO_COMPILADOR=auto|gcc|clang|sin-jit   (por defecto auto)
#   OTP_VERSION=27.3.4.19
#   ASDF_VERSION=v0.14.1
#   CONFIGURAR_SISTEMA=0|1                  (por defecto 1)
#
# El script guarda un log en ~/aplicar_gist_avh_<fecha>.log
# =============================================================================
set -uo pipefail

OTP_VERSION="${OTP_VERSION:-27.3.4.19}"
ASDF_VERSION="${ASDF_VERSION:-v0.14.1}"
REBAR3_URL="${REBAR3_URL:-https://s3.amazonaws.com/rebar3/rebar3}"
MODO_COMPILADOR="${MODO_COMPILADOR:-auto}"
CONFIGURAR_SISTEMA="${CONFIGURAR_SISTEMA:-1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOG="${HOME}/aplicar_gist_avh_$(date +%Y%m%d-%H%M%S).log"

exec > >(tee -a "${LOG}") 2>&1

log()  { printf '\033[0;32m[OK]\033[0m %s\n' "$*"; }
info() { printf '\033[0;34m[..]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!!]\033[0m %s\n' "$*"; }
step() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
fail() {
    printf '\033[0;31m[ERROR]\033[0m %s\n' "$*" >&2
    printf '\nEl log completo está en: %s\n' "${LOG}" >&2
    exit 1
}

if [ "$(id -u)" -eq 0 ]; then
    fail "No ejecutes este script como root. Entra como usuario 'pi'."
fi

command -v sudo >/dev/null 2>&1 || fail "Se necesita sudo."

# -----------------------------------------------------------------------------
# 0. Preflight
# -----------------------------------------------------------------------------
step "0. Verificando hardware y sistema"

ARCH="$(uname -m)"
[ "${ARCH}" = "aarch64" ] || fail "Se esperaba aarch64 y se detectó ${ARCH}."
log "Arquitectura: ${ARCH}"

if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
fi
log "Sistema: ${PRETTY_NAME:-desconocido}"

if [ "${VERSION_CODENAME:-}" = "bullseye" ]; then
    log "Debian 11 (bullseye) detectado: se aplicarán los ajustes del GIST."
else
    warn "Este script está pensado para Debian 11 (bullseye)."
    warn "Sistema detectado: ${PRETTY_NAME:-desconocido}. Continuando de todas formas."
fi

log "Núcleos: $(nproc)"
free -h || true
df -h "${HOME}" || true

info "Comprobando conexión a Internet..."
if command -v curl >/dev/null 2>&1; then
    curl -fsI https://github.com >/dev/null 2>&1 || warn "No se pudo contactar github.com. Revisa la red."
else
    warn "curl no está instalado todavía; se instalará en el siguiente paso."
fi

# -----------------------------------------------------------------------------
# 1. Repositorios de Debian 11 (archive.debian.org)
# -----------------------------------------------------------------------------
step "1. Preparando los repositorios de Debian 11"

if [ -x "${SCRIPT_DIR}/arreglar_apt_bullseye.sh" ]; then
    "${SCRIPT_DIR}/arreglar_apt_bullseye.sh"
else
    warn "No encuentro arreglar_apt_bullseye.sh; se aplicará el ajuste mínimo."
    sudo cp -a /etc/apt/sources.list "/etc/apt/sources.list.bak.$(date +%Y%m%d-%H%M%S)" || true
    for f in /etc/apt/sources.list /etc/apt/sources.list.d/*.list; do
        [ -f "${f}" ] || continue
        sudo sed -i \
            -e 's|https*://deb.debian.org/debian|http://archive.debian.org/debian|g' \
            -e 's|https*://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' \
            "${f}" 2>/dev/null || true
    done
    echo 'Acquire::Check-Valid-Until "false";' \
        | sudo tee /etc/apt/apt.conf.d/99archive >/dev/null
    sudo apt-get update || fail "apt-get update falló."
fi

# -----------------------------------------------------------------------------
# 2. Dependencias (adaptadas del GIST)
# -----------------------------------------------------------------------------
step "2. Instalando dependencias de compilación"

# El GIST incluye libwxgtk3.2-dev, libgl1-mesa-dev, libglu1-mesa-dev,
# libpng-dev, xsltproc y fop. En bullseye no existe wx 3.2 y no se necesita
# GUI para esta práctica, así que se omite y se compila con --without-wx.
PKGS=(
    build-essential
    libssl-dev
    libncurses-dev
    libssh-dev
    unixodbc-dev
    m4
    git
    curl
    wget
    ca-certificates
)

MISSING=()
for pkg in "${PKGS[@]}"; do
    dpkg -s "${pkg}" >/dev/null 2>&1 || MISSING+=("${pkg}")
done

if [ "${#MISSING[@]}" -gt 0 ]; then
    info "Instalando: ${MISSING[*]}"
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "${MISSING[@]}" \
        || fail "No se pudieron instalar las dependencias."
else
    log "Todas las dependencias ya están instaladas."
fi

# -----------------------------------------------------------------------------
# 3. asdf
# -----------------------------------------------------------------------------
step "3. Instalando asdf ${ASDF_VERSION}"

if [ -d "${HOME}/.asdf" ]; then
    log "asdf ya está clonado en ${HOME}/.asdf"
else
    info "Clonando asdf..."
    git clone -q https://github.com/asdf-vm/asdf.git "${HOME}/.asdf" --branch "${ASDF_VERSION}" \
        || fail "No se pudo clonar asdf."
fi

grep -q 'asdf.sh' "${HOME}/.bashrc" 2>/dev/null \
    || echo '. "$HOME/.asdf/asdf.sh"' >> "${HOME}/.bashrc"
grep -q 'asdf.bash' "${HOME}/.bashrc" 2>/dev/null \
    || echo '. "$HOME/.asdf/completions/asdf.bash"' >> "${HOME}/.bashrc"

# shellcheck disable=SC1091
. "${HOME}/.asdf/asdf.sh"
log "asdf: $(asdf --version)"

if ! asdf plugin list 2>/dev/null | grep -qx 'erlang'; then
    info "Agregando plugin erlang..."
    asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git \
        || fail "No se pudo agregar el plugin erlang."
else
    log "Plugin erlang ya instalado."
fi

# -----------------------------------------------------------------------------
# 4. Compilar OTP 27 (con JIT si es posible)
# -----------------------------------------------------------------------------
step "4. Compilando Erlang/OTP ${OTP_VERSION}"

OPCIONES_BASE="--enable-native-libs --enable-kernel-poll --disable-debug --without-javac --without-wx"

guardar_log_kerl() {
    local kerl_log="${HOME}/.asdf/plugins/erlang/kerl-home/builds/asdf_${OTP_VERSION}/otp_build_${OTP_VERSION}.log"
    if [ -f "${kerl_log}" ]; then
        local destino="${HOME}/otp_build_${OTP_VERSION}_$(date +%H%M%S).log"
        cp "${kerl_log}" "${destino}" 2>/dev/null && info "Log de compilación guardado en ${destino}"
    fi
}

limpiar_intento() {
    asdf uninstall erlang "${OTP_VERSION}" >/dev/null 2>&1 || true
    rm -rf "${HOME}/.asdf/plugins/erlang/kerl-home/builds/asdf_${OTP_VERSION}" 2>/dev/null || true
}

compilar_otp() {
    local etiqueta="$1"
    local opciones="$2"
    local cc="${3:-}"
    local cxx="${4:-}"

    info "Intento: ${etiqueta}"
    info "Opciones: ${opciones}"

    if [ -n "${cc}" ]; then
        KERL_CONFIGURE_OPTIONS="${opciones}" CC="${cc}" CXX="${cxx}" \
            asdf install erlang "${OTP_VERSION}"
    else
        KERL_CONFIGURE_OPTIONS="${opciones}" \
            asdf install erlang "${OTP_VERSION}"
    fi
}

instalar_clang() {
    if command -v clang-11 >/dev/null 2>&1; then
        return 0
    fi
    info "Instalando clang-11 como compilador alternativo..."
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq clang-11 \
        || return 1
}

INSTALADO=0

if asdf list erlang 2>/dev/null | grep -q "${OTP_VERSION}"; then
    log "OTP ${OTP_VERSION} ya está instalado; se omite la compilación."
    INSTALADO=1
fi

if [ "${INSTALADO}" -eq 0 ]; then
    GCC_MAJOR="$(gcc -dumpversion 2>/dev/null | cut -d. -f1)"
    GCC_MAJOR="${GCC_MAJOR:-0}"
    if [ "${GCC_MAJOR}" -lt 11 ] 2>/dev/null; then
        warn "gcc ${GCC_MAJOR} detectado. El GIST recomienda gcc >= 11 para el JIT."
        warn "Se intentará de todos modos; si falla, se probará con clang-11 y luego sin JIT."
    else
        log "gcc ${GCC_MAJOR} detectado."
    fi

    case "${MODO_COMPILADOR}" in
        sin-jit)
            compilar_otp "OTP 27 sin JIT" "${OPCIONES_BASE} --disable-jit" \
                && INSTALADO=1
            ;;
        clang)
            instalar_clang || warn "No se pudo instalar clang-11."
            compilar_otp "OTP 27 con JIT (clang-11)" "${OPCIONES_BASE} --enable-jit" clang-11 clang++-11 \
                && INSTALADO=1
            if [ "${INSTALADO}" -eq 0 ]; then
                limpiar_intento
                compilar_otp "OTP 27 sin JIT" "${OPCIONES_BASE} --disable-jit" \
                    && INSTALADO=1
            fi
            ;;
        gcc)
            compilar_otp "OTP 27 con JIT (gcc)" "${OPCIONES_BASE} --enable-jit" \
                && INSTALADO=1
            if [ "${INSTALADO}" -eq 0 ]; then
                guardar_log_kerl
                limpiar_intento
                compilar_otp "OTP 27 sin JIT (gcc)" "${OPCIONES_BASE} --disable-jit" \
                    && INSTALADO=1
            fi
            ;;
        auto|*)
            compilar_otp "OTP 27 con JIT (gcc)" "${OPCIONES_BASE} --enable-jit" \
                && INSTALADO=1

            if [ "${INSTALADO}" -eq 0 ]; then
                guardar_log_kerl
                warn "Falló la compilación con gcc. Probando con clang-11..."
                limpiar_intento
                if instalar_clang; then
                    compilar_otp "OTP 27 con JIT (clang-11)" "${OPCIONES_BASE} --enable-jit" clang-11 clang++-11 \
                        && INSTALADO=1
                fi
            fi

            if [ "${INSTALADO}" -eq 0 ]; then
                guardar_log_kerl
                warn "También falló con clang. Compilando OTP 27 sin JIT..."
                limpiar_intento
                compilar_otp "OTP 27 sin JIT" "${OPCIONES_BASE} --disable-jit" \
                    && INSTALADO=1
            fi
            ;;
    esac
fi

if [ "${INSTALADO}" -eq 0 ]; then
    guardar_log_kerl
    fail "No se pudo compilar OTP ${OTP_VERSION}. Revisa el log de kerl."
fi

asdf global erlang "${OTP_VERSION}" || fail "No se pudo fijar OTP ${OTP_VERSION}."
asdf reshim erlang || true
log "OTP ${OTP_VERSION} instalado y seleccionado."

# -----------------------------------------------------------------------------
# 5. rebar3
# -----------------------------------------------------------------------------
step "5. Instalando rebar3"

mkdir -p "${HOME}/bin"
grep -q 'HOME/bin' "${HOME}/.bashrc" 2>/dev/null \
    || echo 'export PATH="$HOME/bin:$PATH"' >> "${HOME}/.bashrc"
export PATH="${HOME}/bin:${PATH}"

if command -v rebar3 >/dev/null 2>&1; then
    log "rebar3 ya está instalado: $(rebar3 version)"
else
    info "Descargando rebar3 desde el sitio oficial..."
    if ! wget -q "${REBAR3_URL}" -O "${HOME}/bin/rebar3"; then
        warn "Falló la descarga desde ${REBAR3_URL}; probando GitHub."
        curl -fsSL "https://github.com/erlang/rebar3/releases/download/3.21.0/rebar3" \
            -o "${HOME}/bin/rebar3" || fail "No se pudo descargar rebar3."
    fi
    chmod +x "${HOME}/bin/rebar3"
    rebar3 version || fail "rebar3 se descargó pero no se pudo ejecutar."
    log "rebar3 instalado en ${HOME}/bin/rebar3"
fi

# -----------------------------------------------------------------------------
# 6. Proyecto de prueba hello_erlang
# -----------------------------------------------------------------------------
step "6. Creando y compilando hello_erlang"

if [ ! -d "${HOME}/hello_erlang" ]; then
    cd "${HOME}" || fail "No se pudo entrar a ${HOME}."
    rebar3 new release hello_erlang || fail "No se pudo crear hello_erlang."
else
    log "hello_erlang ya existe; se reutiliza."
fi

cd "${HOME}/hello_erlang" || fail "No se pudo entrar a hello_erlang."
rebar3 compile || fail "rebar3 compile falló."
rebar3 release || warn "rebar3 release falló; la compilación básica sí funciona."
rebar3 tar || warn "rebar3 tar falló; el release sigue disponible en _build/."
log "Proyecto hello_erlang compilado."

# -----------------------------------------------------------------------------
# 7. Ajustes del sistema (opcional, adaptados del GIST)
# -----------------------------------------------------------------------------
if [ "${CONFIGURAR_SISTEMA}" = "1" ]; then
    step "7. Aplicando ajustes de red y límites (adaptados del GIST)"

    sudo tee /etc/sysctl.d/99-erlang.conf >/dev/null <<'EOF'
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_tw_reuse = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
EOF
    sudo sysctl -p /etc/sysctl.d/99-erlang.conf >/dev/null 2>&1 \
        && log "sysctl aplicado." || warn "No se pudo aplicar sysctl; no es crítico."

    # El GIST usa el usuario 'distiller'; en AVH el usuario es 'pi'.
    USUARIO="$(whoami)"
    sudo tee /etc/security/limits.d/erlang.conf >/dev/null <<EOF
${USUARIO} soft nofile 524288
${USUARIO} hard nofile 524288
${USUARIO} soft nproc 32768
${USUARIO} hard nproc 32768
EOF
    log "Límites configurados para ${USUARIO} (se aplican al volver a entrar)."
fi

# -----------------------------------------------------------------------------
# 8. Verificación final
# -----------------------------------------------------------------------------
step "8. Verificación final"

OTP_RELEASE="$(erl -noshell -eval 'io:format("~s", [erlang:system_info(otp_release)]), halt().')"
ERTS_VSN="$(erl -noshell -eval 'io:format("~s", [erlang:system_info(version)]), halt().')"
EMU_FLAVOR="$(erl -noshell -eval 'io:format("~p", [erlang:system_info(emu_flavor)]), halt().')"
ARCH_INFO="$(erl -noshell -eval 'io:format("~s", [erlang:system_info(system_architecture)]), halt().')"
SCHEDULERS="$(erl -noshell -eval 'io:format("~p", [erlang:system_info(schedulers_online)]), halt().')"
REBAR_VSN="$(rebar3 version 2>/dev/null | head -1)"

AES="$(erl -noshell -eval '
  ok = crypto:start(),
  io:format("~p", [lists:member(aes_256_gcm, crypto:supports(ciphers))]),
  halt().' 2>/dev/null || echo "error")"

RESUMEN="${HOME}/resumen_gist_avh.txt"
{
    echo "===== RESUMEN APLICACIÓN DEL GIST ====="
    echo "Fecha: $(date -Iseconds)"
    echo "Equipo: $(uname -a)"
    echo "Sistema: ${PRETTY_NAME:-desconocido}"
    echo "OTP: ${OTP_RELEASE}"
    echo "ERTS: ${ERTS_VSN}"
    echo "emu_flavor: ${EMU_FLAVOR}"
    echo "Arquitectura: ${ARCH_INFO}"
    echo "Schedulers: ${SCHEDULERS}"
    echo "rebar3: ${REBAR_VSN}"
    echo "AES-256-GCM: ${AES}"
} | tee "${RESUMEN}"

if [ -d "${PROJECT_ROOT}/evidencias/texto" ]; then
    cp "${RESUMEN}" "${PROJECT_ROOT}/evidencias/texto/04-resumen-gist.txt" 2>/dev/null || true
fi

echo
if [ "${EMU_FLAVOR}" = "jit" ]; then
    log "JIT activo: emu_flavor = jit"
else
    warn "JIT no activo: emu_flavor = ${EMU_FLAVOR}. OTP 27 funciona, pero sin JIT."
    warn "Documenta esta limitación en docs/04-aplicacion-gist.md."
fi

if [ "${OTP_RELEASE}" = "27" ]; then
    log "OTP 27 verificado."
else
    warn "Se esperaba OTP 27 y se obtuvo ${OTP_RELEASE}."
fi

log "Resumen guardado en ${RESUMEN}"
log "Log completo en ${LOG}"
echo
echo "Siguientes pasos:"
echo "  1. Copia ${RESUMEN} y ${LOG} a evidencias/."
echo "  2. Toma capturas de la consola y del panel de AVH."
echo "  3. Apaga la instancia al terminar: sudo poweroff"
