require 'fileutils'
require 'yaml'
configuration = YAML.load_file('configuration.yml')

NODE_COUNT = 2
BOX_IMAGE = "ubuntu/bionic64"

Vagrant.configure("2") do |config|
    config.vm.box = BOX_IMAGE

    config.vm.define "salt-master" do |subconfig|
        subconfig.vm.hostname = "salt-master"

        subconfig.vm.provider "virtualbox" do |v|
            v.name = "salt-master"
            v.memory = 2048
            v.cpus = 2
        end

        subconfig.vm.network :private_network, ip: "10.0.0.10"

        configuration['shared-folders'].each do |mounted, local|
            subconfig.vm.synced_folder local, mounted, nfs: false
        end

        subconfig.vm.provision "shell" do |s|
            s.path = "provision/01_salt.sh"
            s.args = [
                "master",
                configuration['parameters']['salt-version'],
                "localhost"
            ]
        end
    end

    (1..NODE_COUNT).each do |i|
        config.vm.define "salt-minion-#{i}" do |subconfig|
            subconfig.vm.hostname = "salt-minion-#{i}"
            subconfig.vm.provider "virtualbox" do |v|
                v.name = "salt-minion-#{i}"
                v.memory = 1024
                v.cpus = 1
            end

            subconfig.vm.network :private_network, ip: "10.0.0.1#{i}"

            configuration['shared-folders'].each do |mounted, local|
                subconfig.vm.synced_folder local, mounted, nfs: false
            end

            subconfig.vm.provision "shell" do |s|
                s.path = "provision/01_salt.sh"
                s.args = [
                    "minion",
                    configuration['parameters']['salt-version'],
                    "10.0.0.10"
                ]
            end
        end
    end
end