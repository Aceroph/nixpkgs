{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  name = "minecraft-loading-plymouth";
  version = "0.0.1";

  src = fetchFromGitHub {
    repo = "minecraft-loading-plymouth";
    owner = "Aceroph";
    hash = "sha256-aF4Ro5z4G6LS40ENwFDH8CgV7ldfhzqekuSph/DMQoo=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth/themes/minecraft-loading
    cp -r $src/{*.plymouth,images} $out/share/plymouth/themes/minecraft-loading/
    substituteInPlace $out/share/plymouth/themes/minecraft-loading/*.plymouth --replace '@IMAGES@' "$out/share/plymouth/themes/minecraft-loading/images"

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "The minecraft world loading screen for plymouth";
    homepage = "https://github.com/Aceroph/minecraft-loading-plymouth";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
