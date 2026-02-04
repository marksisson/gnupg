{ flake-parts-lib, ... }: {
  options = {
    perSystem = flake-parts-lib.mkPerSystemOption
      ({ lib, ... }: with lib; with types; {
        options = {
          environment = mkOption { type = package; };
        };
      });
  };

  config = {
    perSystem = { pkgs, ... }: {
      environment = pkgs.buildEnv {
        name = "environment";
        paths = with pkgs; [ age gnupg just ];
        pathsToLink = [ "/bin" ];
      };
    };
  };
}
