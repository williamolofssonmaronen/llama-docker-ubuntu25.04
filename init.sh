#!/bin/bash

MODEL_DIR="models"
MODEL_FILE="Llama-3.1-8b"
TOKEN_ENV="token.env.gpg"

# Decrypt and load environment variables
if [ ! -f "$TOKEN_ENV" ]; then
  echo "❌ Encrypted token file $TOKEN_ENV not found."
  exit 1
fi

echo "🔐 Decrypting $TOKEN_ENV..."
eval $(gpg --quiet --batch --decrypt "$TOKEN_ENV" | grep -E '^[A-Z_]+=') || {
  echo "❌ Failed to decrypt or parse $TOKEN_ENV"
  exit 1
}

if [ -z "$HF_TOKEN" ]; then
  echo "❌ HF_TOKEN is not set after decryption."
  exit 1
fi

# Ensure model directory exists
mkdir -p "$MODEL_DIR"

# Download model if missing
if [ ! -d "$MODEL_DIR/$MODEL_FILE" ]; then
  echo "🔄 Downloading model..."
  huggingface-cli login --token $HF_TOKEN
  huggingface-cli download meta-llama/Llama-3.1-8B --include "original/*" --local-dir $MODEL_DIR/$MODEL_FILE
  if [ $? -ne 0 ]; then
    echo "❌ Failed to download model. Exiting."
    exit 1
  fi
  echo "✅ Model downloaded."
else
  echo "✅ Model already exists."
fi
