# Biblioteca `Blur.BlurEffect` com suporte a corner radius, usada pela extensão
# blur-my-shell para corrigir os cantos arredondados sob blur dinâmico.
# Ver: https://github.com/aunetx/blur-my-shell/blob/master/scripts/GUIDE.md
#
# Ela é compilada contra o mutter em uso, então precisa ser reconstruída a cada
# atualização do GNOME — o que aqui acontece sozinho, já que a derivação depende
# de `pkgs.mutter`. O upstream fixa a API 18 do mutter (GNOME 50); quando o GNOME
# subir de versão o build vai falhar explicitamente até o upstream se atualizar.

# ============== Feito pelo Claude, não tenho habilidade de fazer isso ==============
{
  # O overlay deixa o pacote disponível como `pkgs.gnome-rounded-blur` em
  # qualquer módulo (NixOS ou home), sem callPackage por caminho relativo.
  flake.overlays.gnome-rounded-blur = final: _prev: {
    gnome-rounded-blur = final.callPackage (
      {
        lib,
        stdenv,
        fetchFromGitHub,
        meson,
        ninja,
        pkg-config,
        gobject-introspection,
        glib,
        mutter,
        cairo,
        wayland,
        libglvnd,
        gsettings-desktop-schemas,
        at-spi2-core,
        libxkbcommon,
        lcms2,
        libx11,
        libxfixes,
        libxi,
      }:

      stdenv.mkDerivation {
        pname = "gnome-rounded-blur";
        version = "1.0.0-unstable-2026-08-09";

        src = fetchFromGitHub {
          owner = "kancko";
          repo = "gnome-rounded-blur";
          rev = "f3bfcc796e1214c1e1d4287ee35cb132ad8133f0";
          hash = "sha256-MBeb0/Drt0UQ/K8UaW93ae9OaV3L5nhFZB2tPwj47co=";
        };

        nativeBuildInputs = [
          meson
          ninja
          pkg-config
          gobject-introspection
        ];

        # mutter, glib e cairo vêm dos `Requires` do libmutter-18.pc; o resto é a
        # cadeia transitiva que o pkg-config precisa resolver para gerar os cflags.
        buildInputs = [
          glib
          mutter
          cairo
          wayland
          libglvnd
          gsettings-desktop-schemas
          at-spi2-core
          libxkbcommon
          lcms2
          libx11
          libxfixes
          libxi
        ];

        # O mutter instala os .so em $out/lib/mutter-<api>, fora do rpath padrão.
        NIX_LDFLAGS = "-L${mutter}/lib/mutter-18";

        meta = {
          description = "Blur.BlurEffect com suporte a corner radius para extensões do GNOME Shell";
          homepage = "https://github.com/kancko/gnome-rounded-blur";
          license = lib.licenses.gpl3Plus;
          platforms = lib.platforms.linux;
        };
      }
    ) { };
  };

  # E também como saída do flake: `nix build .#gnome-rounded-blur`.
  perSystem =
    { pkgs, ... }:
    {
      packages.gnome-rounded-blur = pkgs.gnome-rounded-blur;
    };
}
