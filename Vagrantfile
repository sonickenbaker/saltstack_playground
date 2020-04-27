require 'fileutils'
require 'yaml'
configuration = YAML.load_file('configuration.yml')
parameters = configuration.fetch('parameters', {})

NODE_COUNT = parameters['node-count']
BOX_IMAGE = "ubuntu/bionic64"

Vagrant.configure("2") do |config|
    config.vm.box = BOX_IMAGE
    master_addr = parameters.key?('master-addr') ? parameters['master-addr'] : "10.0.0.10"

    if not parameters.fetch('minions-only', false)
        config.vm.define "salt-master" do |subconfig|
            subconfig.vm.hostname = "salt-master"

            subconfig.vm.provider "virtualbox" do |v|
                v.name = "salt-master"
                v.memory = parameters['master']['memory']
                v.cpus = parameters['master']['cpus']
            end

            subconfig.vm.network :private_network, ip: master_addr

            configuration['shared-folders'].each do |mounted, local|
                subconfig.vm.synced_folder local, mounted, nfs: false
            end

            subconfig.vm.provision "shell" do |s|
                s.path = "provision/01_salt.sh"
                s.args = [
                    "master",
                    parameters['salt-version'],
                    "localhost"
                ]
            end
        end
    end

    (1..NODE_COUNT).each do |i|
        config.vm.define "salt-minion-#{i}" do |subconfig|
            subconfig.vm.hostname = "salt-minion-#{i}"
            subconfig.vm.provider "virtualbox" do |v|
                v.name = "salt-minion-#{i}"
                v.memory = parameters['minion']['memory']
                v.cpus = parameters['minion']['cpus']
            end

            subconfig.vm.network :private_network, ip: "10.0.0.1#{i}"

            configuration['shared-folders'].each do |mounted, local|
                subconfig.vm.synced_folder local, mounted, nfs: false
            end

            subconfig.vm.provision "shell" do |s|
                s.path = "provision/01_salt.sh"
                s.args = [
                    "minion",
                    parameters['salt-version'],
                    master_addr
                ]
            end
        end
    end
end