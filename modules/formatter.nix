{ inputs, ... }: {
  imports = with inputs.parts; [
    components.nixology.parts.formatter
  ];
}
