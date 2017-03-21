# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$cpus   = ENV.fetch("ISLANDORA_VAGRANT_CPUS", "1")
$memory = ENV.fetch("ISLANDORA_VAGRANT_MEMORY", "3072")
$hostname = ENV.fetch("ISLANDORA_VAGRANT_HOSTNAME", "claw")
$virtualBoxDescription = ENV.fetch("ISLANDORA_VAGRANT_VIRTUALBOXDESCRIPTION", "IslandoraCLAW")

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  config.vm.provider "virtualbox" do |v|
    v.name = "Islandora CLAW"
    config.vm.network :forwarded_port, guest: 8000, host: 8000 # Apache
  end
  
  config.vm.hostname = $hostname
 
  # This should work fine out of the box if environment variables are declared
  config.vm.provider :digital_ocean do |provider, override|
    provider.ssh_key_name = ENV['DIGITALOCEAN_KEYNAME']
    override.ssh.private_key_path = ENV['DIGITALOCEAN_KEYPATH']
    override.ssh.username = "vagrant"
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    provider.token = ENV['DIGITALOCEAN_TOKEN']
    provider.image = 'ubuntu-14-04-x64'
    provider.region = 'tor1'
    provider.size = '4gb'
    override.vm.network :forwarded_port, guest: 80, host: 80
  end
  
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/xenial64"

  # Setup the shared folder
  home_dir = "/home/ubuntu"
  config.vm.synced_folder ".", home_dir + "/islandora"

  config.vm.network :forwarded_port, guest: 8080, host: 8080 # Tomcat
  config.vm.network :forwarded_port, guest: 8181, host: 8181 # Karaf
  config.vm.network :forwarded_port, guest: 8282, host: 8282 # Islandora Microservices
  config.vm.network :forwarded_port, guest: 3306, host: 3306 # MySQL
  config.vm.network :forwarded_port, guest: 5432, host: 5432 # PostgreSQL
  #config.vm.network :forwarded_port, guest: 8383, host: 8383 # Loris
  config.vm.network :forwarded_port, guest: 8983, host: 8983 # Solr

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", $memory]
    vb.customize ["modifyvm", :id, "--cpus", $cpus]
    vb.customize ["modifyvm", :id, "--description", $virtualBoxDescription]
  end

  config.vm.provision :shell, inline: "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile", :privileged =>false
  config.vm.provision :shell, :path => "./scripts/bootstrap.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/lamp-server.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/fits.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/solr.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/composer.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/drupal.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/fcrepo.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/blazegraph.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/syn.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/karaf.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/alpaca.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/islandora-karaf-components.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/config.sh", :args => home_dir
  config.vm.provision :shell, :path => "./scripts/post-install.sh", :args => home_dir
end
