{
  autoPatchelfHook,
  gcc,
  gnumake,
  gtk2-x11,
  lib,
  makeWrapper,
  stdenv,
  xorg,
  build ? "103187",
  libraries ? [ ],
  platform ? "linux-x86-64",
  version ? "19.05",
}:

stdenv.mkDerivation {
  pname = "eiffelstudio-bin";
  version = version;
  src = fetchTarball {
    url = "https://sourceforge.net/projects/eiffelstudio/files/EiffelStudio%20${version}/Build_${build}/Eiffel_${version}_gpl_${build}-${platform}.tar.bz2/download";
    sha256 = "sha256:1m96qg581m1hfjaycc0i0v96vlhs7y0nl9slxk0qb24x3ki2xpjf";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    gtk2-x11
    makeWrapper
    xorg.libXtst
  ];

  buildInputs = [
    gnumake
    gcc
  ];

  installPhase = ''
    runHook preInstall

      mkdir -p $out/bin
      cp -r . $out

      substituteInPlace $out/studio/spec/${platform}/include/config.sh --replace-fail /bin/ ""
      makeWrapper $out/studio/spec/${platform}/bin/estudio $out/bin/estudio \
        --set ISE_EIFFEL $out \
        --set ISE_PLATFORM ${platform} \
        --prefix PATH : ${
          lib.makeBinPath [
            gcc
            gnumake
          ]
        }

      find $out/studio/spec/${platform}/bin/ ! -name estudio -exec ln -s {} $out/bin/ \;

      ${lib.concatStringsSep "\n" (
        lib.forEach libraries (elib: "ln -s ${elib} $out/contrib/library/${elib.name}")
      )}

      runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.eiffel.com/eiffelstudio/";
    description = "IDE for one programming language, Eiffel.";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aceroph ];
    mainProgram = "estudio";
  };
}
