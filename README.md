# rsensor-flake

A Nix flake for building and running [rsensor](https://github.com/tahuffman1s/rsensor) - a lightweight system monitoring tool written in Rust that provides real-time CPU monitoring, memory usage statistics, and GPU monitoring with a clean, responsive terminal interface.

## Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- Linux system (rsensor is Linux-only)

To enable flakes, add this to your `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

## Installation & Usage

### Run directly (no installation)

```bash
nix run github:tahuffman1s/rsensor-flake
```

### Install to your profile

```bash
nix profile install github:tahuffman1s/rsensor-flake
rsensor
```

### Use with NixOS configuration

Add the input to your `flake.nix`:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    rsensor = {
      url = "github:tahuffman1s/rsensor-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

Then in your NixOS configuration:
```nix
{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    # ... other packages
    inputs.rsensor.packages.${pkgs.system}.default
  ];
}
```

### Use with Home Manager

Add the input to your `flake.nix`:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    
    rsensor = {
      url = "github:tahuffman1s/rsensor-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

Then in your Home Manager configuration:
```nix
{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # ... other packages
    inputs.rsensor.packages.${pkgs.system}.default
  ];
}
```

## Development Environment

### Enter the development shell

```bash
nix develop github:tahuffman1s/rsensor-flake
```

Or clone this repository and use it locally:
```bash
git clone https://github.com/tahuffman1s/rsensor-flake
cd rsensor-flake
nix develop
```

### What's included in the dev shell

The development shell provides:
- `rustc` - Rust compiler
- `cargo` - Rust package manager
- `rust-analyzer` - Rust language server
- `pkg-config` - Package configuration tool
- `pciutils` - PCI utilities (runtime dependency)

### Working with the source code

Once in the development shell, you can clone and work on the original rsensor repository:

```bash
git clone https://github.com/tahuffman1s/rsensor
cd rsensor
cargo vendor
cargo build
cargo run
```

### Building locally

To build the flake locally:
```bash
nix build
```

The built binary will be available at `./result/bin/rsensor`.

## Features

rsensor provides:
- Real-time CPU monitoring
- Memory usage statistics  
- GPU monitoring
- Clean, responsive terminal interface
- Desktop integration (`.desktop` file and icon included)

## Requirements

- Linux system (uses Linux-specific APIs for hardware monitoring)
- `pciutils` package (automatically included as runtime dependency)

## License

This flake packages rsensor which is licensed under the MIT License. See the [original repository](https://github.com/tahuffman1s/rsensor) for more details.

## Contributing

Issues and pull requests should be directed to the appropriate repository:
- For rsensor functionality: [tahuffman1s/rsensor](https://github.com/tahuffman1s/rsensor)
- For this flake: [tahuffman1s/rsensor-flake](https://github.com/tahuffman1s/rsensor-flake)
