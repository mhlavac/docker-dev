# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.require_version ">= 1.6.0"
require 'yaml'

Vagrant.configure("2") do |config|
  user_config = YAML.load_file 'config.yml'

  config.vm.provider "docker" do |d|
    d.image = user_config['image']
    d.has_ssh = true
    d.ports = user_config['port_mapping']
    d.remains_running = true
  end

  config.vm.hostname = "container"
  config.vm.synced_folder "./", "/var/www/app", create: true

  config.ssh.username = "dev"
  config.ssh.port = 22
  config.ssh.private_key_path = ["id_rsa", user_config['developer']['ssh_key'], user_config['git']['ssh_key']]
  config.ssh.forward_agent = true

  config.vm.provision "shell", privileged: false, inline: '
    git config --global user.name "' + user_config['git']['username'] + '" && /
    git config --global user.email "' + user_config['git']['email'] + '"
  '

  config.vm.provision "shell", run: "always", inline: '
    echo "127.0.0.1 my_dev" >> /etc/hosts &&
    chown -R dev:dev /var/www/app
  '
end
