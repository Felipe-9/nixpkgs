{ callPackage, ... }@_args:

let
  base = callPackage ./generic.nix (
    _args
    // {
      version = "8.3.22";
      hash = "sha256-mRM+LNoq83uqedsX2O/UFGKPFKAux18UGKCqP2qmZzs=";
    }
  );
in
base.withExtensions (
  { all, ... }:
  with all;
  ([
    bcmath
    calendar
    curl
    ctype
    dom
    exif
    fileinfo
    filter
    ftp
    gd
    gettext
    gmp
    iconv
    imap
    intl
    ldap
    mbstring
    mysqli
    mysqlnd
    opcache
    openssl
    pcntl
    pdo
    pdo_mysql
    pdo_odbc
    pdo_pgsql
    pdo_sqlite
    pgsql
    posix
    readline
    session
    simplexml
    sockets
    soap
    sodium
    sysvsem
    sqlite3
    tokenizer
    xmlreader
    xmlwriter
    zip
    zlib
  ])
)
