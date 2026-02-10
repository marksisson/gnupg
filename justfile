gnupg_directory := "~/.config/gnupg"
gnupg_encrypted_data := "gnupg.age"

[default]
@_:
  just --list

backup: prepare_gnupg_directory
  #!/usr/bin/env bash
  export GNUPGHOME={{gnupg_directory}}
  gpgconf --kill gpg-agent
  (cd {{gnupg_directory}} || exit; tar -chz *.conf *.d *.db *.gpg *.kbx) | age -p < /dev/tty > {{justfile_directory()}}/{{gnupg_encrypted_data}}
  gpgconf --launch gpg-agent  

restore: prepare_gnupg_directory
  #!/usr/bin/env bash
  set -o pipefail
  export GNUPGHOME={{gnupg_directory}}
  gpgconf --kill gpg-agent

  echo $HEADER "Decrypting gnupg configuration..."
  until age --decrypt {{justfile_directory()}}/{{gnupg_encrypted_data}} < /dev/tty \
    | tar --directory {{gnupg_directory}} -xz; do
    echo $ERROR "Wrong password or decryption failed. Try again."
  done

  echo $SUCCESS "Restore successful."
  gpgconf --launch gpg-agent

[private]
@prepare_gnupg_directory:
  mkdir -p {{gnupg_directory}}
  chmod 700 {{gnupg_directory}}
