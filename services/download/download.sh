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
  /data/embeddings \
  /data/config/ \
  /data/models/ \
  /data/models/Stable-diffusion \
  /data/models/GFPGAN \
  /data/models/RealESRGAN \
  /data/models/LDSR \
  /data/models/VAE  \
  /data/models/ControlNet \
  /data/models/ControlNet/models

#####################################################################################################################################
echo "Downloading Mikubill/sd-webui-controlnet repository archive..."
download "https://github.com/Mikubill/sd-webui-controlnet/archive/refs/heads/main.zip" "/tmp/sd-webui-controlnet.zip"

echo "Extracting files..."
unzip /tmp/sd-webui-controlnet.zip -d /tmp

echo "Copying files to /data/config/auto/extensions/sd-webui-controlnet..."
mkdir -p /data/config/auto/extensions/sd-webui-controlnet
cp -r /tmp/sd-webui-controlnet-main/* /data/config/auto/extensions/sd-webui-controlnet

echo "Cleaning up..."
rm -rf /tmp/sd-webui-controlnet.zip /tmp/sd-webui-controlnet-main
######################################################################################################################################
######################################################################################################################################
echo "Downloading Mikubill/sd-webui-controlnet repository archive..."
download "https://github.com/glucauze/sd-webui-faceswaplab/archive/refs/heads/main.zip" "/tmp/sd-webui-faceswaplab.zip"

echo "Extracting files..."
unzip /tmp/sd-webui-faceswaplab.zip -d /tmp

echo "Copying files to /data/config/auto/extensions/sd-webui-faceswaplab..."
mkdir -p /data/config/auto/extensions/sd-webui-faceswaplab
cp -r /tmp/sd-webui-faceswaplab-main/* /data/config/auto/extensions/sd-webui-faceswaplab

echo "Cleaning up..."
rm -rf /tmp/sd-webui-faceswaplab.zip /tmp/sd-webui-faceswaplab-main
######################################################################################################################################
echo "Downloading, this might take a while..."
aria2c -x 10 --disable-ipv6 --input-file /docker/links.txt --dir /data --continue
