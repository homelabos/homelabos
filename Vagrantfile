Vagrant.require_version ">= 1.7.0"

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/bionic64"
  config.disksize.size = "20GB"

  config.ssh.insert_key = false

  config.vm.network "forwarded_port", id: "http", guest: 80, host: 2280, auto_correct: true
  config.vm.network "forwarded_port", id: "https", guest: 443, host: 2281, auto_correct: true
  config.vm.network "forwarded_port", id: "traefik-dashboard", guest: 8181, host: 2282, auto_correct: true

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "vvv"
    ansible.playbook = "playbook.homelabos.yml"
    ansible.groups = {
      "homelabos" => ["default","testtinc"],
      "vagrant" => ["default"],
    }
    ansible.extra_vars = 'settings/test_config.yml'
  end
end
