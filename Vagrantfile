# -*- mode: ruby -*-
# frozen_string_literal: true

require 'yaml'
require File.expand_path(File.dirname(__FILE__).to_s + '/src/phalcon.rb')

VAGRANTFILE_API_VERSION ||= 2

Vagrant.require_version '>= 1.9.8'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  phalcon = Phalcon.new(config)
  phalcon.configure

  config.vm.provision :shell, path: File.expand_path(File.dirname(__FILE__).to_s + '/scripts/cleanup.sh')
  config.vm.provision :shell, inline: 'echo Vagrant Box created!'
end
