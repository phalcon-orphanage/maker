# -*- mode: ruby -*-
# frozen_string_literal: true

# Copy user files over to VM
class Files
  COPY_FILES = [
    { from: './ansible/roles', to: '/etc/ansible/roles' },
    { from: './ansible', to: '/tmp/ansible' },
  ].freeze

  attr_accessor :config

  def initialize(config)
    @config = config

    create_ansible_dirs
  end

  def configure
    COPY_FILES.each do |file|
      config.vm.provision :file do |f|
        f.source = File.expand_path(file[:from])
        f.destination = File.join file[:to]
      end
    end
  end

  private

  def create_ansible_dirs
    config.vm.provision :shell do |s|
      s.inline = <<-EOM
        mkdir -p /etc/ansible/roles
        sudo chmod o+w /etc/ansible/roles
      EOM
    end
  end
end
