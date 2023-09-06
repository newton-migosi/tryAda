# A simple Ada project

This repository contains a Hello World Ada program following the [`ada_language_server` set up tutorial](https://github.com/AdaCore/ada_language_server/wiki/Getting-Started).

We use nix flakes to provision `gdb`, `gnat12` and `gprbuild`. The flake also provides a `vscodium` executable with preinstalled extensions, specifically `adacore.ada` and `webfreak.debug`.

With nix installed,

- `nix develop` to enter a nix shell.
- `nix run .#codium` to launch the IDE.
- `nix run .#writeSettings` to update the vscodium settings
- `nix run .#hello_world` to build and run the Ada project executable

## Errors

The `adacore.ada` extension fails to find the Ada toolchain in its path, even though they are in scope in the integrated terminal.

```sh
$ gnatls -v

GNATLS 12.3.0
Copyright (C) 1997-2022, Free Software Foundation, Inc.

Source Search Path:
   <Current_Directory>
   /nix/store/mr05cj10vqj8vylvw4f7vgd5giipdyjx-gnat-12.3.0/lib/gcc/x86_64-unknown-linux-gnu/12.3.0/adainclude


Object Search Path:
   <Current_Directory>
   /nix/store/mr05cj10vqj8vylvw4f7vgd5giipdyjx-gnat-12.3.0/lib/gcc/x86_64-unknown-linux-gnu/12.3.0/adalib


Project Search Path:
   <Current_Directory>
   /nix/store/mr05cj10vqj8vylvw4f7vgd5giipdyjx-gnat-12.3.0/x86_64-unknown-linux-gnu/lib/gnat
   /nix/store/mr05cj10vqj8vylvw4f7vgd5giipdyjx-gnat-12.3.0/x86_64-unknown-linux-gnu/share/gpr
   /nix/store/mr05cj10vqj8vylvw4f7vgd5giipdyjx-gnat-12.3.0/share/gpr
   /nix/store/mr05cj10vqj8vylvw4f7vgd5giipdyjx-gnat-12.3.0/lib/gnat
```

Also, `$PATH` in the IDE has the required binaries (`gnat-wrapper`, `gprbuild`, `gdb`):

```sh
$ echo $PATH
/nix/store/7fyks463qlrq5mi8a5jdnqw74h8rwn54-devshell-dir/bin:/nix/store/148x9bca5p18var9kj79pc3d589djrk8-bash-interactive-5.2-p15/bin:/path-not-set:/nix/store/7k5ycffnnkghisa76xrk7j9kgy0vhj5a-glib-2.76.3-bin/bin:/nix/store/148x9bca5p18var9kj79pc3d589djrk8-bash-interactive-5.2-p15/bin:/nix/store/i4r4am1hf82qknwxnp449fa9yzk44gz4-rnix-lsp-unstable-2022-11-27/bin:/nix/store/f18iig5c415f81gmiyyzrzglgsyyaijs-nixpkgs-fmt-1.3.0/bin:/nix/store/wq5805kdns8g1wbcm4f1xkh14mvclbpj-direnv-2.32.3/bin:/nix/store/148x9bca5p18var9kj79pc3d589djrk8-bash-interactive-5.2-p15/bin:/nix/store/bvp8a8zpkp3zji1nxpgcgh2ncwvkhf5v-gnat-wrapper-12.3.0/bin:/nix/store/q7r3bhwhiazi2drhcwb47chnfb96j2vx-gprbuild-23.0.0/bin:/nix/store/alzprwcam78airwgyl12mmgjsad8zs11-gdb-13.2/bin:/home/user/.nvm/versions/node/v18.14.2/bin:/home/user/anaconda3/bin:/home/user/anaconda3/condabin:/home/user/.cargo/bin:/home/user/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin:/home/user/.cabal/bin:/home/user/.ghcup/bin
```

The `adacore.ada` raises the following error when in a `.adb` file

```text
The project was loaded, but no Ada runtime found. Please check the installation of the Ada compiler.
```

The `adacore.ada` extension raises the following error when in a `.gpr` file

```text
can't find a toolchain for the following configuration: language 'Ada', target 'x86_64-linux', default runtime
```
