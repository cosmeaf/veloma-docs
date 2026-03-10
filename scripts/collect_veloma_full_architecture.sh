#!/usr/bin/env bash
# =============================================================================
# Veloma Architecture Collector - Versão Limpa 2025/2026
# =============================================================================

set -u

OUTPUT="/tmp/veloma_architecture_report_$(date +%Y%m%d_%H%M%S).txt"
PROJECT="/opt/veloma-app"
IPINTEL="/opt/ipintel"

# Diretórios e padrões a excluir (separados por |)
EXCLUDE_PATTERNS="venv|__pycache__|migrations|static|media|logs|cache|node_modules|.git|.pytest_cache|.coverage|htmlcov|.DS_Store|*.pyc|*.pyo"

echo "=========================================" | tee "$OUTPUT"
echo "  Veloma Architecture Collector"        | tee -a "$OUTPUT"
echo "  $(date '+%Y-%m-%d %H:%M:%S')"         | tee -a "$OUTPUT"
echo "=========================================" | tee -a "$OUTPUT"
echo ""                                       | tee -a "$OUTPUT"
echo "Output file: $OUTPUT"                   | tee -a "$OUTPUT"
echo ""                                       | tee -a "$OUTPUT"

log() {
    echo "$1" | tee -a "$OUTPUT"
}

section() {
    echo ""                                 | tee -a "$OUTPUT"
    echo "══════════════════════════════════════════" | tee -a "$OUTPUT"
    echo " $1"                             | tee -a "$OUTPUT"
    echo "══════════════════════════════════════════" | tee -a "$OUTPUT"
    echo ""                                 | tee -a "$OUTPUT"
}

# =============================================================================
section "PROJECT STRUCTURE (clean – maxdepth 4)"

find "$PROJECT" \
    \( -type d \( -name venv -o -name __pycache__ -o -name migrations -o -name static -o -name media -o -name logs -o -name cache -o -name node_modules -o -name .git -o -name .pytest_cache \) -prune \) \
    -o -type d -maxdepth 4 -print \
    2>/dev/null | sort | tee -a "$OUTPUT"

# =============================================================================
section "IPINTEL STRUCTURE (clean – maxdepth 4)"

find "$IPINTEL" \
    \( -type d \( -name venv -o -name __pycache__ -o -name migrations -o -name logs -o -name cache -o -name .git \) -prune \) \
    -o -type d -maxdepth 4 -print \
    2>/dev/null | sort | tee -a "$OUTPUT"

# =============================================================================
section "DJANGO MODELS"

find "$PROJECT" \
    \( -type d \( -name venv -o -name __pycache__ -o -name migrations \) -prune \) \
    -o -type f -name "*.py" -exec grep -H "class .*models\.Model" {} + \
    2>/dev/null | sort | tee -a "$OUTPUT"

# =============================================================================
section "SERIALIZERS"

find "$PROJECT" \
    \( -type d \( -name venv -o -name __pycache__ -o -name migrations \) -prune \) \
    -o -type f -name "*.py" -exec grep -H -E "(class|from).*Serializer" {} + \
    2>/dev/null | sort | tee -a "$OUTPUT"

# =============================================================================
section "VIEWSETS / GENERIC VIEWSETS"

find "$PROJECT" \
    \( -type d \( -name venv -o -name __pycache__ -o -name migrations \) -prune \) \
    -o -type f -name "*.py" -exec grep -H -E "(class|from).*(ViewSet|GenericViewSet)" {} + \
    2>/dev/null | sort | tee -a "$OUTPUT"

# =============================================================================
section "CELERY TASKS (@shared_task / @task)"

find "$PROJECT" \
    \( -type d \( -name venv -o -name __pycache__ \) -prune \) \
    -o -type f -name "*.py" -exec grep -H -E "@(shared_task|task)" {} + \
    2>/dev/null | sort | tee -a "$OUTPUT"

# =============================================================================
section "DRF ROUTERS (router.register)"

find "$PROJECT" \
    \( -type d \( -name venv -o -name __pycache__ \) -prune \) \
    -o -type f -name "*.py" -exec grep -H "router\.register" {} + \
    2>/dev/null | sort | tee -a "$OUTPUT"

# =============================================================================
section "INSTALLED_APPS + MIDDLEWARE (core/settings.py)"

if [[ -f "$PROJECT/core/settings.py" ]]; then
    grep -A 35 -B 5 -E "INSTALLED_APPS|MIDDLEWARE" "$PROJECT/core/settings.py" \
        2>/dev/null | tee -a "$OUTPUT"
else
    log "Arquivo core/settings.py não encontrado"
fi

# =============================================================================
section "EMAIL SERVICE"

if [[ -d "$PROJECT/services/email" ]]; then
    find "$PROJECT/services/email" -maxdepth 1 -type f -name "*.py" -o -name "*.pyi" \
        | sort | tee -a "$OUTPUT"
else
    log "Diretório services/email não encontrado"
fi

# =============================================================================
section "IPINTEL ENGINES"

if [[ -d "$IPINTEL/engine" ]]; then
    find "$IPINTEL/engine" -maxdepth 1 -type f -name "*.py" \
        | sort | tee -a "$OUTPUT"
else
    log "Diretório ipintel/engine não encontrado"
fi

# =============================================================================
echo ""                                 | tee -a "$OUTPUT"
echo "══════════════════════════════════════════" | tee -a "$OUTPUT"
echo "  Coleta finalizada"             | tee -a "$OUTPUT"
echo "  Arquivo gerado em: $OUTPUT"    | tee -a "$OUTPUT"
echo "══════════════════════════════════════════" | tee -a "$OUTPUT"
echo ""