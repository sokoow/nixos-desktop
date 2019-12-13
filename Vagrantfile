Vagrant.configure("2") do |config|

	config.vm.box = "stefandeml/nixos-19.09-x86_64"
  config.vm.box_version = "0.1.0"

  # Setup networking
	# FIXME: NixOS cannot accept Linuxlike network setting with vagrant
	# config.vm.network "private_network", :ip => "172.16.16.16"
  config.ssh.forward_agent = true
  config.disksize.size = '50GB'

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "3092"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--cpus", 2]
  end

	# Add the htop package
	# config.vm.provision :nixos, :expression => {
	# 	environment: {
	# 		systemPackages: [ :htop ]
	# }
	# }
	config.vm.provision :shell, inline: "nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager"
	config.vm.provision :shell, inline: "nix-channel --update"

  config.vm.provision :nixos,
    :path => "./configuration.nix"

	config.vm.provision :shell, inline: "reboot"

end
