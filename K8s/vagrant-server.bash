## Vagrant-server


VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "ubuntu/jammy64"


 
  config.vm.hostname = "server"
  config.vm.network "public_network", ip: "192.168.56.12", hostname: true


  config.vm.provider :virtualbox do |vb|


   
    vb.customize [
      'modifyvm', :id,
      '--memory', '2048',
      '--cpus', '2'
    ]
  end

 
end


## Vagrant-agent


VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "ubuntu/jammy64"


 
  config.vm.hostname = "agent"
  config.vm.network "public_network", ip: "192.168.56.13", hostname: true


  config.vm.provider :virtualbox do |vb|


   
    vb.customize [
      'modifyvm', :id,
      '--memory', '1024',
      '--cpus', '1'
    ]
  end

 
end

