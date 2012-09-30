#
# This class installs Oracle Java for CentOS / RHEL
# 
define java::setup (
  $customSetup  = {},
  $customConf   = {},
  $ensure       = installed,
  $boot         = true,
  $status       = 'running',
  $version      = '5.1.5',
  $firewall     = false,
  $firewallPort = '8082',
) {
  
  include conf
  $defaultConf = $conf::conf
  $defaultSetup = $conf::setup

  #
  # Setup JAVA if not exists
  # 
  # unless => "rpm -q --quiet jdk-1.6.0_21-fcs"
  #
  exec { "java-common-download":
    command => "wget -O /tmp/sun-javadb-common-10.6.2-1.1.i386.rpm https://dl.dropbox.com/u/7225008/Java/sun-javadb-common-10.6.2-1.1.i386.rpm",
  }

  exec { "java-common-install":
    command => "rpm -ivh /tmp/sun-javadb-common-10.6.2-1.1.i386.rpm",
    require => Exec['java-common-download']
  }

  exec { "java-jdk-download":
    command => "wget -O /tmp/jdk-6u32-ea-linux-amd64.rpm https://dl.dropbox.com/u/7225008/Java/jdk-6u32-ea-linux-amd64.rpm",
    require => Exec['java-common-install']
  }

  exec { "java-jdk-install":
    command => "rpm -ivh /tmp/jdk-6u32-ea-linux-amd64.rpm",
    require => Exec['java-jdk-download']    
  }

  exec { "java-client-download":
    command => "wget -O /tmp/sun-javadb-client-10.6.2-1.1.i386.rpm https://dl.dropbox.com/u/7225008/Java/sun-javadb-client-10.6.2-1.1.i386.rpm",
    require => Exec['java-jdk-install']
  }

  exec { "java-client-install":
    command => "rpm -ivh /tmp/sun-javadb-client-10.6.2-1.1.i386.rpm",
    require => Exec['java-client-download']
  }

  exec { "java-core-download":
    command => "wget -O /tmp/sun-javadb-core-10.6.2-1.1.i386.rpm https://dl.dropbox.com/u/7225008/Java/sun-javadb-core-10.6.2-1.1.i386.rpm",
    require => Exec['java-client-install']
  }

  exec { "java-core-install":
    command => "rpm -ivh /tmp/sun-javadb-core-10.6.2-1.1.i386.rpm",
    require => Exec['java-core-download']
  }

  exec { "java-home-env":
    command => "echo JAVA_HOME=\"/usr/java/jdk1.6.0_32\" >> /etc/environment && export JAVA_HOME=/usr/java/jdk1.6.0_32",
  }

# https://dl.dropbox.com/u/7225008/Java/sun-javadb-demo-10.6.2-1.1.i386.rpm
# https://dl.dropbox.com/u/7225008/Java/sun-javadb-docs-10.6.2-1.1.i386.rpm
# https://dl.dropbox.com/u/7225008/Java/sun-javadb-javadoc-10.6.2-1.1.i386.rpm
}