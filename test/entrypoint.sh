#!/bin/bash
set -e

echo "⏳ Pulling llama3 model inside container..."
ollama pull llama3

echo "🚀 Starting Ollama server..."
exec ollama serve --host 0.0.0.0

chmod +x entrypoint.sh
