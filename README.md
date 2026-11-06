# homebrew-oosama

My tap repository with formulas and casks I use

## Install

```bash
brew tap Gridness/oosama
brew install <formula>
```

Install the Rea CLI with:

```bash
brew install gridness/oosama/rea
rea setup
```

Rea installs as a standalone binary distribution with its runtime and dependencies
included. Homebrew does not install Node.js, npm, or Bun. Native analysis uses a
separately configured Hopper, Ghidra, or IDA installation. See the
[upstream setup guide](https://github.com/morluto/rea/blob/main/docs/installation.md).

Install the itch.io Butler CLI on macOS or Linux with:

```bash
brew install gridness/oosama/butler
```

## Upgrade

```bash
brew upgrade <formula>
```

## Automated updates

SpacetimeDB checks for new releases every six hours and pushes formula updates
directly to `main`.

Rea checks for new stable releases every six hours and builds standalone archives
for macOS and Linux on ARM64 and x86-64. Each build tests the CLI, a JavaScript
analysis worker, agent setup, native PTY support, and the MCP server with runtime
tools absent from `PATH`. It publishes all four archives as a release in this tap
and pushes the formula URLs, version, and checksums directly to `main`.

Butler checks itch.io's stable download channels every six hours. When all four
macOS and Linux channels agree on a newer release, it validates their archives
and pushes the new version and checksums directly to `main`.

The workflows also support manual runs from the GitHub Actions tab.
