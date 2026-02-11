# Resume

A portable LaTeX resume builder.

## Prerequisites

- [Nix](https://nixos.org/download/) with flakes enabled
- [direnv](https://direnv.net/) (optionally)

## Setup

Enter the dev shell:

```sh
nix develop
```

Or if using direnv:

```sh
cp .envrc.example .envrc
direnv allow
```

### Phone number

The phone number is injected at build time via the `PHONE_NUMBER` environment variable to keep it out of version control. Create a `.env` file:

```sh
echo 'PHONE_NUMBER=+1 555-123-4567' > .env
```

direnv will load `.env` automatically. Without it, you can pass it directly:

```sh
make PHONE_NUMBER="+1 555-123-4567"
```

## Usage

Build the PDF:

```sh
make
```

Watch for changes and rebuild automatically:

```sh
make watch
```

Clean build artifacts:

```sh
make clean
```

You can also build the PDF as a Nix package directly:

```sh
nix build
```

The output will be in `result/my_resume.pdf`.
