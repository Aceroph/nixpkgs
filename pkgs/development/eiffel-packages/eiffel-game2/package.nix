{
  eiffel-studio-bin,
  fetchFromGitHub,
  lib,
  stdenv,
  SDL2,
  SDL2_gfx,
  SDL2_image,
  SDL2_ttf,
  openal,
  libsndfile,
  libmpg123,
  libepoxy,
  libGL,
  libGLU,
  glew,
  ffmpeg,
  platform ? "linux-x86-64",
}:

stdenv.mkDerivation {
  pname = "eiffel-game2";
  version = "2025-10-07";
  src = fetchFromGitHub {
    repo = "Eiffel_Game2";
    owner = "tioui";
    rev = "7f45f4a75fded5cc132a5d356013d77dd1bce294";
    fetchSubmodules = true;
    sha256 = "sha256-J8h76tT8cgvsH1hiQyFeubatB2LzExuZQJN4kOK5FFU=";
  };

  ISE_PLATFORM = platform;
  ISE_EIFFEL = eiffel-studio-bin;

  nativeBuildInputs = [
    eiffel-studio-bin
    SDL2
    SDL2_gfx
    SDL2_image
    SDL2_ttf
    openal
    libsndfile
    libmpg123
    libepoxy
    libGL
    libGLU
    glew
    ffmpeg
  ];

  buildPhase = ''
    runHook preBuild

    ./compile_c_library.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/game2
    cp -r . $out/lib/game2
    substituteInPlace $out/lib/game2/audio/{audio,audio_3d}.ecf --replace-fail "/usr/include/AL" "${openal}/include/AL"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.eiffelgame2.org/";
    description = "A Game library for ISE Eiffel.";
    license = licenses.efl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aceroph ];
  };
}
