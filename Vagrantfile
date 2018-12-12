Vagrant.require_version ">= 1.7.0"

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/bionic64"
  config.disksize.size = "20GB"

  config.ssh.insert_key = false

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "homelabos.yml"
    ansible.groups = { "homelabos" => ["default"] }
    ansible.extra_vars = { ansible_ssh_user: 'vagrant',
                ansible_python_interpreter:"/usr/bin/python3",
                ansible_connection: 'ssh',
                ansible_ssh_args: '-o ForwardAgent=yes'}
  end
end
