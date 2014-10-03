# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "base"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :private_network, ip: "192.168.33.101"
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", "vagrant-symfony-sandbox"]
  end

  config.vm.synced_folder "./puppet/", "/puppet", id: "puppet-root", create: false, :nfs => false
  config.vm.synced_folder "./application/", "/vagrant", id: "vagrant-root", create: true, :nfs => false

  config.vm.provider :virtualbox do |vb|
#    vb.customize ['modifyvm', :id, '--usb', 'on']
#    vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'huawei', '--vendorid', '0x12d1', '--productid', '0x1001']
  end

  # This shell provisioner installs librarian-puppet and runs it to install
  # puppet modules. After that it just runs puppet

  config.vm.provision :shell, :path => "shell/bootstrap.sh"

end
