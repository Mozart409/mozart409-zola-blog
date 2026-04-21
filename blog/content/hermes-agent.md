+++
title = "Hermes Agent with NixOS"
date = 2026-04-21
+++

## TLDR

Just show me the [code](https://github.com/Mozart409/pve-nixos-homelab/blob/main/hosts/hermes/configuration.nix)

I only have access to a Nvidia GeForce 3060 with 12gb vram and its installed in to my main desktop pc, that why I have opencode zen as a main provider configured.

```nix
# Agenix secrets - contains OPENAI_API_KEY and OPENAI_BASE_URL for OpenCode Zen
age.secrets.hermes-opencode-zen-key = {
  file = ../../secrets/hermes-opencode-zen-key.age;
  mode = "0400";
};
```
