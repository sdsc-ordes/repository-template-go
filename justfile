set positional-arguments
set shell := ["bash", "-cue"]
root_dir := `git rev-parse --show-toplevel`
flake_dir := root_dir / "tools/nix"
output_dir := root_dir / ".output"
build_dir := output_dir / "build"

mod nix "./tools/just/nix.just"

# Default target if you do not specify a target.
default:
    just --list --unsorted

# Enter the default Nix development shell and execute the command `"$@`.
develop *args:
    just nix::develop "default" "$@"

# Format the project.
format *args:
    "{{root_dir}}/tools/scripts/setup-config-files.sh"
    nix run --accept-flake-config {{flake_dir}}#treefmt -- "$@"

# Setup the project.
setup *args:
    cd "{{root_dir}}" && ./tools/scripts/setup.sh

# Run commands over the ci development shell.
ci *args:
    just nix::develop "ci" "$@"

main_package := "tool"
# Lint the project.
lint *args:
    cd "src/{{main_package}}" && \
    golangci-lint run \
        --max-issues-per-linter 0 \
        --max-same-issues 0 \
        --timeout 10m0s \
        --config "{{root_dir}}/tools/configs/golangci-lint/golangci.yaml" \
        "$@"

# Build the project.
build *args:
    mkdir -p "{{build_dir}}/{{main_package}}" && \
    export GOBIN="{{build_dir}}/{{main_package}}" && \
    cd "src/{{main_package}}" && \
        go generate "$@" ./... && \
        go install "$@" ./...

# Test the project.
test *args:
    cd "src/{{main_package}}" && \
        go test "$@" ./...

# Run an executable.
run *args:
    cd "src/{{main_package}}" && \
        go run "$@" ./cmd/cli/...
