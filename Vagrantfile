Vagrant.configure("2") do |config|   
    config.vm.box = "fedora/34-cloud-base"

        config.vm.provider "virtualbox" do |vb|   
        vb.memory = "4024"   
        vb.cpus = "1"   
    end

 config.vm.provision "ansible" do |ansible|  
        ansible.ask_become_pass = true
        ansible.verbose = "v"
        ansible.playbook = "./playbook.yml"
    end  
end