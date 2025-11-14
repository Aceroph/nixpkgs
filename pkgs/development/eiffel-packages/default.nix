{ callPackage, eiffel-studio-bin, ... }:

{
  game2 = callPackage ./eiffel-game2 { inherit eiffel-studio-bin; };
}
