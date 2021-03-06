# -*- mode: ruby -*-
# vi: set ft=ruby :

box = "centos/7"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = box

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "private_network", type: "dhcp"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL


  config.vm.define "webapp" do |webapp|
    webapp.vm.network "forwarded_port", guest: 22, host: 2221
    webapp.vm.synced_folder "./src/db", "/home/isucon/torb/db", type: "virtualbox", owner:"isucon", group:"isucon"
    webapp.vm.synced_folder "./src/src", "/home/isucon/torb/webapp/go/src", type: "virtualbox", owner:"isucon", group:"isucon"
    webapp.vm.provision "shell", inline: <<-SHELL
      set -e
      yum update -y
      yum install -y ansible git

      GITDIR="/tmp/torb"
      rm -rf ${GITDIR}
      git clone -b new_master https://github.com/masayanakajima/isucon-setup.git ${GITDIR}
      sed -i '/^BUNDLED WITH/,$d' ${GITDIR}/webapp/ruby/Gemfile.lock
      (
        cd ${GITDIR}/provisioning
        cat >local <<EOF
[webapp1]
localhost ansible_connection=local
EOF
        PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook -i local webapp1.yml
      )
      rm -rf ${GITDIR}
    SHELL
  end

  config.vm.define "db" do |db|
    db.vm.network "forwarded_port", guest: 22, host: 2222
    db.vm.provision "shell", inline: <<-SHELL
      set -e
      yum update -y
      yum install -y ansible git

      GITDIR="/tmp/torb"
      rm -rf ${GITDIR}
      git clone -b new_master https://github.com/masayanakajima/isucon-setup.git ${GITDIR}
      sed -i '/^BUNDLED WITH/,$d' ${GITDIR}/webapp/ruby/Gemfile.lock
      (
        cd ${GITDIR}/provisioning
        cat >local <<EOF
[db]
localhost ansible_connection=local
EOF
        PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook -i local db.yml
      )
      rm -rf ${GITDIR}      
    SHELL
  end

  config.vm.define "bench" do |bench|
    bench.vm.network "forwarded_port", guest: 22, host: 2223
    bench.vm.provision "shell", inline: <<-SHELL
      set -e
      yum update -y
      yum install -y ansible git

      GITDIR="/tmp/torb"
      rm -rf ${GITDIR}
      git clone -b new_master https://github.com/masayanakajima/isucon-setup.git ${GITDIR}
      sed -i '/^BUNDLED WITH/,$d' ${GITDIR}/webapp/ruby/Gemfile.lock
      (
        cd ${GITDIR}/provisioning
        cat >local <<EOF
[bench]
localhost ansible_connection=local
EOF
        sed -i -e '/start_bench_worker/s/^/#/' bench.yml
        PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook -i local bench.yml
      )
      rm -rf ${GITDIR}
    SHELL
  end
end
