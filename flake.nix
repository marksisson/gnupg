{
  inputs.parts.url = "git+ssh://git@github.com/marksisson/parts";

  outputs = inputs:
    let flakeref = "github:marksisson/gnupg"; in with inputs.parts; with lib;
    mkFlake { inherit flakeref inputs; } { imports = modulesIn ./modules; };
}
