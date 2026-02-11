{
  description = "Resume build environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-small
            latexmk

            # Add packages you need
            moderncv
            fontawesome5
            multirow
            arydshln
            enumitem
            titlesec
            geometry
            hyperref
            xcolor
            preprint
            marvosym
            fancyhdr
            babel
            tools
            charter

            # Fonts
            lato
            raleway
            roboto;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            tex
            gnumake

            # Optional: for live preview
            entr # File watcher

            # Version control
            git
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.zathura ]
          ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.skim ];

          shellHook = ''
            echo "Resume build environment loaded!"
            echo "Commands available:"
            echo "  make          - Build PDF"
            echo "  make watch    - Auto-rebuild on changes"
            echo "  make clean    - Clean auxiliary files"
          '';
        };

        # Build the resume as a Nix package (without phone number substitution)
        # For full builds with secrets, use: make PHONE_NUMBER="..."
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "resume";
          version = "1.0.0";
          src = ./.;

          nativeBuildInputs = [ tex ];

          buildPhase = ''
            cp resume.tex resume_build.tex
            if [ -n "''${PHONE_NUMBER:-}" ]; then
              sed -i "s/PHONE\\\\_NUMBER/$PHONE_NUMBER/" resume_build.tex
            fi
            pdflatex resume_build.tex
            pdflatex resume_build.tex
          '';

          installPhase = ''
            mkdir -p $out
            cp resume_build.pdf $out/my_resume.pdf
          '';
        };
      });
}
