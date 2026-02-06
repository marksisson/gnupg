{ self, ... }: {
  perSystem = { config, lib, pkgs, ... }:
    let
      pinentry-program =
        if pkgs.stdenv.hostPlatform.isDarwin then
          lib.getExe' pkgs.pinentry_mac "pinentry-mac"
        else
          lib.getExe' pkgs.pinentry-tty "pinentry-tty";
    in
    {
      apps.default.program = pkgs.writeShellScriptBin "activate" ''
        export PATH=${config.environment}/bin:$PATH

        just --justfile ${self + "/justfile"} restore

        export GNUPGHOME="$HOME/.config/gnupg"

        gpgconf --kill gpg-agent

        CONF="$GNUPGHOME/gpg-agent.conf"
        {
          grep -v '^pinentry-program' "$CONF" 2>/dev/null
          echo "pinentry-program ${pinentry-program}"
        } > "$CONF.tmp" && mv -f "$CONF.tmp" "$CONF" && chmod 600 "$CONF"

        gpgconf --launch gpg-agent
      '';
    };
}
