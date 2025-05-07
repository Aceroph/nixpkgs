{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  name = "minecraft-loading-plymouth";
  version = "0.0.2";

  src = fetchFromGitHub {
    repo = "minecraft-loading-plymouth";
    owner = "Aceroph";
    rev = "3f4054d7246341a95084d9dbbd3b77ecbea36d6d";
    hash = "sha256-aF4Ro5z4G6LS40ENwFDH8CgV7ldfhzqekuSph/DMQoo=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth/themes/minecraft-loading
    cp -r $src/{*.plymouth,images} $out/share/plymouth/themes/minecraft-loading/
    replaceVars $out/share/plymouth/themes/minecraft-loading/*.plymouth --replace '@SRC@' "$out/share/plymouth/themes/minecraft-loading"

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
