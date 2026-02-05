{
  inputs.parts.url = "github:marksisson/parts";

  outputs = inputs:
    let flakeref = "github:marksisson/gnupg"; in with inputs.parts; with lib;
    mkFlake { inherit flakeref inputs; } { imports = modulesIn ./modules; };
}
