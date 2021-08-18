class baseconfig {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update';
  }

  exec {'echo':
    command => '/usr/bin/echo "hola" >> /vagrant/txt1.txt';
  }

  package { ['apache2', 'tree']:
    ensure => present;
  }

  file { '/var/www/html/index.html':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source => 'puppet:///modules/baseconfig/index.html',
    path    => '/var/www/html/index.html';
  }

  service { "apache2":
    ensure => running,
    enable => true,
    require => Package['apache2'];
  }

  exec {'Crear contenedor':
    command => '/usr/bin/lxc launch ubuntu:20.04 PuppetServer';
  }

  exec {'Instalar apache2 en contenedor':
    command => '/usr/bin/lxc exec PuppetServer -- sudo apt-get install apache2 -y';
  }

  exec {'Cambiar el index.html':
    command => '/usr/bin/lxc file push /vagrant/index.html PuppetServer/var/www/html/index.html';
  }

  exec {'Redireccionamiento de puerto servidor:3082 => contenedor:80':
    command => '/usr/bin/lxc config device add PuppetServer port80 proxy listen=tcp:192.168.2.2:3082 connect=tcp:127.0.0.1:80';
  }


}
