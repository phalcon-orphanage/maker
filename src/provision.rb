# -*- mode: ruby -*-
# frozen_string_literal: true

# Configure provisions
class Provision
  attr_accessor :config, :settings, :provider

  def initialize(config, settings, provider)
    @config = config
    @settings = settings
    @provider = provider
  end

  # Start Shell provisioning
  def shell
    config.vm.provision :shell, path: './scripts/setup.sh'
    vmware_provision
  end

  # Start Ansible provisioning
  def ansible
    config.vm.provision 'ansible_local' do |ansible|
      ansible.playbook = '/ansible/ubuntu1604.yml'
      ansible.limit = :all
      ansible.galaxy_roles_path = '/etc/ansible/roles'
      ansible.galaxy_role_file  = '/ansible/requirements.yml'
      ansible.compatibility_mode = '2.0'
      ansible.extra_vars = { settings: settings }
      ansible.verbose = settings[:verbose]
    end
  end

  private

  def vmware_provision
    return unless %i(vmware_desktop vmware_fusion vmware_workstation).include? provider

    config.vm.provision :shell, path: './scripts/vmware.sh'
  end
end
