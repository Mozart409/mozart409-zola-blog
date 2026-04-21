#!/usr/bin/env bash
set -euo pipefail

main() {
  ZOLA_VERSION=0.22.1
  TINYSEARCH_VERSION=0.10.0

  curl -sLJO "https://github.com/getzola/zola/releases/download/v${ZOLA_VERSION}/zola-v${ZOLA_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
  tar -xf zola-v${ZOLA_VERSION}-x86_64-unknown-linux-gnu.tar.gz

  curl -sLJO "https://github.com/tinysearch/tinysearch/releases/download/v${TINYSEARCH_VERSION}/tinysearch-v${TINYSEARCH_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  tar -xf tinysearch-v${TINYSEARCH_VERSION}-x86_64-unknown-linux-musl.tar.gz

  git submodule update --init --recursive

  # Run zola from the blog directory where zola.toml is located
  cd blog && ../zola build
}

main
