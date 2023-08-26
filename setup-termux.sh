#!/usr/bin/env bash

# Set up storage
termux-setup-storage

# Update and upgrade packages
pkg update && pkg upgrade

# Install tools and repositories
pkg install -y \
  *-repo termux-* \
  curl \
  zsh \
  python3 \
  python-pip \
  ruby \
  git \
  wget \
  proot \
  proot-distro \
