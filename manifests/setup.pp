#
# This class installs Oracle Java for CentOS / RHEL
# 
# TODO: prepare unattended -i silent with common bin
# TODO: unless => "rpm -q --quiet jdk"
# 
define java::setup (
  $customSetup  = {},
  $customConf   = {},
  $ensure       = installed,
  $boot         = true,
  $status       = 'running',
  $version      = '6u32',
  $firewall     = false,
  $firewallPort = false,
) {
  
  include conf
  $defaultConf = $conf::conf
  $defaultSetup = $conf::setup

  # exec { "java-download":
  #   command => "wget -O /tmp/java.rpm.bin find url for java",
  #   unless => "rpm -q --quiet jdk"
  # }

  # exec { "java-install":
  #   command => "chmod a+x /tmp/java.rpm.bin && ./java.rpm.bin",
  #   unless => "rpm -q --quiet jdk",
  #   require => Exec['java-download']
  # }

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
}