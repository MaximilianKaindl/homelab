#!/bin/sh
set -eu

/bin/ollama serve &
ollama_pid=$!

cleanup() {
  kill "$ollama_pid" 2>/dev/null || true
  wait "$ollama_pid" 2>/dev/null || true
}

trap cleanup INT TERM

until ollama list >/dev/null 2>&1; do
  sleep 5
done

for model in "$OLLAMA_DEFAULT_MODEL" $OLLAMA_EXTRA_MODELS; do
  ollama pull "$model"
done

# Preload the default model with an empty prompt so it is ready after startup.
ollama run "$OLLAMA_DEFAULT_MODEL" "" >/dev/null 2>&1 || true

wait "$ollama_pid"
