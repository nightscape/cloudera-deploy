require 'yaml'

# Load settings from vagrant.local.yaml or vagrant.yaml
current_dir = File.dirname(File.expand_path(__FILE__))
potential_config_files = ["vagrant.local.yaml", "vagrant.yaml"].map { |f| "#{current_dir}/#{f}" }

config_file = potential_config_files.find { |f| File.file?(f) }
config = YAML.load_file(config_file)
hosts = config["hosts"]

ENV["LC_ALL"] = "en_US.UTF-8"
start_at_task = ENV['START_AT_TASK']
ansible_args = (ENV['ANSIBLE_ARGS'] || "").split(" ")

Vagrant.configure("2") do |config|
  N = hosts.length
  hosts.each_with_index do |h, i|
    host_name = h["name"]
    config.vm.define host_name do |node|
      node.vm.box      = h["base_image"]
      node.vm.hostname = host_name
      node.vm.disk "disk", size: "64GiB"
      (h["synced_folders"] || []).each { |f| node.vm.synced_folder f["from"], f["to"], type: "nfs" }
      node.vm.network  "private_network", ip: "10.0.0.#{11+i}"
      node.vm.network  "forwarded_port", guest: 7180, host: 8080 if i == 0
      node.vm.provider "virtualbox" do |v|
        v.name   = host_name
        v.memory = h["memory"]
        v.cpus   = h["cpus"]
        v.customize ["modifyvm", :id, "--audio", "none"]
      end
      # Start ansible when provisioning the last host
      # in order to prevent race conditions where it starts
      # working but not all machines have been started
      if i == N - 1
        node.vm.provision "ansible" do |ansible|
          ansible.limit = "all"
          ansible.playbook = h["playbook"]
          ansible.start_at_task = start_at_task
          ansible.raw_arguments = ansible_args.compact
        end
      end
    end
  end
end
