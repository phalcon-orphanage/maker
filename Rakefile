# -*- mode: ruby -*-
# frozen_string_literal: true

require 'fileutils'

CWD = File.dirname(__FILE__)
DEFAULT_PROVIDER = 'virtualbox'.freeze
DISTRO_RELEASE = 'ubuntu-16.04'.freeze
SUPPORTED_PROVIDERS = %i(vmware_desktop vmware_fusion vmware_workstation virtualbox).freeze
VMWARE_PROVIDERS = %i(vmware_desktop vmware_fusion vmware_workstation).freeze

VMWARE_DISK_PATH = '.vagrant/machines/maker/vmware_fusion/*-*-*-*-*'.freeze
VMWARE_DISK_MANAGER = '/Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager'.freeze

BANNER = "What provider do you want to use? (default: #{DEFAULT_PROVIDER}): "
         .freeze

task default: %w[all]

desc 'Build Vagrant Box and prepare it to release'
task :all => [:destroy, :build] do
end

desc 'Build Vagrant Box'
task :build do
  provider = ask "\n#{BANNER}"
  provider ||= DEFAULT_PROVIDER

  if SUPPORTED_PROVIDERS.include? provider
    abort("Unsupported provider: #{provider}")
  end

  ENV['VAGRANT_DEFAULT_PROVIDER'] = provider
  build_image provider
end

desc 'Destroy Vagrant Box'
task :destroy do
  run 'vagrant destroy -f'
  FileUtils.rm_rf('.vagrant')
end

def build_image(provider)
  log_file = "#{CWD}/logs/#{provider}-#{DISTRO_RELEASE}.log"

  run "time vagrant up --provider=#{provider} 2>&1 | tee #{log_file}"
  run 'vagrant halt'

  defrag provider
  shrink provider

  package provider
end

def defrag(provider)
  return unless VMWARE_PROVIDERS.include? provider

  run "#{VMWARE_DISK_MANAGER} -d .vagrant/machines/maker/#{provider}/*-*-*-*-*/disk-cl1.vmdk"
end

def shrink(provider)
  return unless VMWARE_PROVIDERS.include? provider

  run "#{VMWARE_DISK_MANAGER} -k .vagrant/machines/maker/#{provider}/*-*-*-*-*/disk-cl1.vmdk"
end

def package(provider)
  if VMWARE_PROVIDERS.include? provider
    package_vmware(provider)
  else
    package_virtualbox
  end
end

def package_vmware(provider)
  Dir.chdir(".vagrant/machines/maker/#{provider}/*-*-*-*-*") do
    FileUtils.rm_f('vmware.log')
    run "tar cvzf ../../../../../builds/#{provider}-ubuntu-16.04.box *"
  end

  process_info Dir["./builds/#{provider}-ubuntu-16.04.box"].to_s
end

def package_virtualbox
  run 'vagrant package --base maker --output builds/virtualbox-ubuntu-16.04.box'
end

def print_when_success(message)
  if $?.exitstatus.zero?
    info(message)
  end
end

def exit_when_failed!(message)
  if $?.exitstatus != 0
    warning(message)
  end
end

def ansi
  {
    green:    "\e[32m",
    red:      "\e[31m",
    white:    "\e[37m",
    bold:     "\e[1m",
    on_green: "\e[42m",
    ending:   "\e[0m"
  }
end

def run(command)
  `#{command}`
end

def say(message, type = :white, newline = true)
  message = "#{ansi[type]}#{message}#{ansi[:ending]}"
  if newline
    puts message
  else
    print message
  end
end

def process_info(message)
  puts "#{ansi[:bold]}#{ansi[:green]}#{message}#{ansi[:ending]}#{ansi[:ending]}"
end

def info(message)
  puts "#{ansi[:green]}#{ansi[:bold]}#{message}#{ansi[:ending]}#{ansi[:ending]}"
end

def warning(message)
  puts "#{ansi[:red]}#{ansi[:bold]}#{message}#{ansi[:ending]}#{ansi[:ending]}"
end

def ask(question, type = :white)
  say(question, type, false)
  answer = STDIN.gets.chomp
  if answer == '' || answer.nil?
      nil
  else
      answer
  end
end

def indent(count)
  ' ' * count
end

def colorize(string, color)
  "#{ansi[color]}#{string}#{ansi[:ending]}"
end
