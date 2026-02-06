gnupg_directory := "~/.config/gnupg"
gnupg_encrypted_data := "gnupg.age"

[default]
@_:
  just --list

backup: prepare_gnupg_directory
  export GNUPGHOME={{gnupg_directory}}
  gpgconf --kill gpg-agent
  (cd {{gnupg_directory}} || exit; tar -chz *.conf *.d *.db *.gpg *.kbx) | age -p < /dev/tty > {{justfile_directory()}}/{{gnupg_encrypted_data}}
  gpg-connect-agent reloadagent /bye

restore: prepare_gnupg_directory
  export GNUPGHOME={{gnupg_directory}}
  gpgconf --kill gpg-agent
  age --decrypt {{justfile_directory()}}/{{gnupg_encrypted_data}} < /dev/tty | tar --directory {{gnupg_directory}} -xz
  gpg-connect-agent reloadagent /bye

[private]
@prepare_gnupg_directory:
  mkdir -p {{gnupg_directory}}
  chmod 700 {{gnupg_directory}}
