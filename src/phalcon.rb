# -*- mode: ruby -*-
# frozen_string_literal: true

require_relative 'provider'
require_relative 'settings'
require_relative 'vbguest'
require_relative 'networks'
require_relative 'vurtualbox'
require_relative 'vmware'
require_relative 'ports'
require_relative 'folders'
require_relative 'files'
require_relative 'provision'

# The main Phalcon Maker class
class Phalcon
  attr_accessor :config, :settings, :provider

  def initialize(config)
    @config = config

    s = Settings.new
    @settings = s.settings

    configure_ssh
    configure_provider
    configure_box
  end

  def configure
    configure_vbguest
    configure_networks
    configure_vms
    configure_ports
    configure_folders
    configure_files
    configure_shell_provision
  end

  private

  # Configure provider
  def configure_provider
    provider = Provider.new
    @provider = provider.current
  end

  # Configure SSH
  def configure_ssh
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
    config.ssh.forward_agent = true
    config.ssh.insert_key = false
  end

  # Configure the Box
  def configure_box
    config.vm.define settings[:name], primary: true do |c|
      c.vm.box = settings[:box]
      c.vm.hostname = settings[:hostname]
      c.vm.box_check_update = settings[:check_update]
    end
  end

  # Configure Virtualbox Guest Additions
  def configure_vbguest
    vbguest = Vbguest.new(config, settings)
    vbguest.configure
  end

  # Configure networks
  def configure_networks
    networks = Networks.new(config, settings)
    networks.configure
  end

  # Configure VMs
  def configure_vms
    virtualbox = Virtualbox.new(config, settings)
    virtualbox.configure

    vmware = VMWare.new(config, settings)
    vmware.configure
  end

  # Configure custom ports
  def configure_ports
    ports = Ports.new(config, settings)
    ports.configure
  end

  # Register all of the configured shared folders
  def configure_folders
    folders = Folders.new(config)
    folders.configure
  end

  # Copy user files over to VM
  def configure_files
    files = Files.new(config)
    files.configure
  end

  # Run sell provision
  def configure_shell_provision
    provision = Provision.new(config, settings, provider)

    provision.shell
    provision.ansible
  end
end
