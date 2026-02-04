{ inputs, ... }: {
  imports = with inputs.parts; [ components.nixology.parts.devShells ];
  perSystem = { config, ... }:
    {
      shells.default.packages = [ config.environment ];
    };
}
