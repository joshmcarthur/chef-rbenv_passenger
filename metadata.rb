maintainer       "Fletcher Nichol"
maintainer_email "fnichol@nichol.ca"
license          "Apache 2.0"
description      "Installs and configures Passenger under RBENV with Apache or nginx"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.8.3"

recipe "rbenv_passenger",           "Installs Passenger gem with rbenv"
recipe "rbenv_passenger::apache2",  "Enables Apache module configuration for passenger under rbenv"
recipe "rbenv_passenger::nginx",    "Installs Passenger gem w/ rbenv, and recompiles support into Nginx"

depends "rbenv",      ">= 0.8.0"
depends "nginx",    "~> 0.101.0"
depends "apache2",  "~> 1.1.8"

supports "ubuntu"
supports "debian"
supports "suse"
supports "centos"
supports "redhat"
