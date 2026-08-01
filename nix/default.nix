{ lib
, stdenv
, bash
, coreutils
, sassc
, ...
}:

stdenv.mkDerivation {
  pname = "colloid-gtk-theme";
  version = "3.6.2";

  src = ../.;

  nativeBuildInputs = [
    bash
    coreutils
    sassc
  ];

  patchPhase = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall

    HOME="$TMPDIR" ./install.sh \
      --dest $out/share/themes

    runHook postInstall
  '';

  meta = {
    description = "Colloid GTK Theme";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
