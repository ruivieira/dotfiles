Vagrant.configure("2") do |config|   
    config.vm.box = "fedora/34-cloud-base"

        config.vm.provider "virtualbox" do |vb|   
        vb.memory = "4024"   
        vb.cpus = "1"   
    end

 config.vm.provision "ansible" do |ansible|  
        ansible.become = true  
        ansible.verbose = "v"          
        # ansible.extra_vars = "ansible_extra_vars.yml"  
        # ansible.vault_password_file="~/.vault_pass.txt"  
        ansible.playbook = "./playbook.yml"  
    end  
end