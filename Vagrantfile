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
    config.vm.provider "docker" do |d|
      d.name = host_name
      d.build_dir = "."
    end
  end
end
