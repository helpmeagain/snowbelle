{
  description = "Projeto Python";

  inputs.nixpkgs.url = "nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python3
          uv
          ruff
        ];

        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc
          pkgs.zlib
        ];

        UV_PYTHON_DOWNLOADS = "never";
        UV_PYTHON = "${pkgs.python3}/bin/python3";
      };
    };
}
