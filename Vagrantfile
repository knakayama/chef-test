# -*- mode: ruby -*-
# vim: set ft=ruby :

# read envs
Dotenv.load

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box     = "ec2"
    config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.vm.provider :aws do |aws, override|
        override.ssh.username         = ENV['AWS_SSH_USERNAME']
        override.ssh.private_key_path = ENV['AWS_SSH_KEY_PATH']
        override.ssh.pty              = false

        aws.access_key_id     = ENV['AWS_ACCESS_KEY_ID']
        aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
        aws.keypair_name      = ENV['AWS_KEYPAIR_NAME']
        aws.region            = "ap-northeast-1"
        aws.ami               = "ami-29dc9228"
        aws.instance_type     = "t2.micro"
        aws.security_groups   = [ENV['AWS_SECURITY_GROUP']]
        aws.tags              = {
            'Name'        => 'chef-test',
            'Description' => 'chef-test',
        }
        #aws.elastic_ip        = true
        aws.user_data         = <<EOT
#!/bin/sh
echo "Defaults    !requiretty" > /etc/sudoers.d/vagrant-init
chmod 440 /etc/sudoers.d/vagrant-init
sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
sudo sed -i -e 's@UTC$@Asia/Tokyo@' -e 's/true/false/' /etc/sysconfig/clock
sudo yum -y update
EOT
    end

    #config.vm.provision "shell", inline: $script

    # install or update chef
    config.omnibus.chef_version = :latest

    # chef-solo
    config.vm.provision :chef_solo do |chef|
        chef.custom_config_path = "Vagrantfile.chef"
        chef.cookbooks_path = ["cookbooks", "site-cookbooks"]
        chef.data_bags_path = "data_bags"
        chef.run_list = %w[
            recipe[yum]
            recipe[yum-epel]
            recipe[nginx]
            recipe[php-env::php55]
            recipe[ruby-env]
            recipe[nodejs]
        ]
    end
end
