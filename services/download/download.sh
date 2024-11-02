#!/usr/bin/env bash
set -Eeuo pipefail

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

download() {
  local url="$1"
  local output="$2"

  if command_exists "curl"; then
    curl -L "$url" -o "$output"
  elif command_exists "wget"; then
    wget -O "$output" "$url"
  else
    echo "Error: Neither curl nor wget is available." >&2
    exit 1
  fi
}

mkdir -vp /data/.cache \
  /data/models/Lora\
  /data/embeddings \
  /data/config/ \
  /data/models/ \
  /data/models/Stable-diffusion \
  /data/models/GFPGAN \
  /data/models/RealESRGAN \
  /data/models/LDSR \
  /data/models/VAE  \
  /data/models/ControlNet \
  /data/models/ControlNet/models\
  

#####################################################################################################################################
# Downloading and extracting sd-webui-controlnet
echo "Downloading adnanbaqi/sd-webui-controlnet repository archive..."
download "https://github.com/adnanbaqi/sd-webui-controlnet/archive/refs/heads/master.zip" "/tmp/sd-webui-controlnet.zip"

echo "Extracting files..."
unzip /tmp/sd-webui-controlnet.zip -d /tmp

echo "Copying files to /data/config/auto/extensions/sd-webui-controlnet..."
mkdir -p /data/config/auto/extensions/sd-webui-controlnet
cp -r /tmp/sd-webui-controlnet-master/* /data/config/auto/extensions/sd-webui-controlnet

echo "Cleaning up..."
rm -rf /tmp/sd-webui-controlnet.zip /tmp/sd-webui-controlnet-master
######################################################################################################################################
######################################################################################################################################

echo "Downloading, this might take a while..."
aria2c -x 4 --disable-ipv6 --input-file /docker/links.txt --dir /data --continue
