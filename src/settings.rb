# -*- mode: ruby -*-
# frozen_string_literal: true

# Initialize user settings
class Settings
  attr_accessor :settings

  DEFAULT_IP = '192.168.50.4'
  DEFAULT_CPUS = 2
  DEFAULT_MEMORY = 2048

  DEFAULT_SETTINGS = {
    name: 'maker',
    box:  'phalconphp/xenial64',
    check_update: true,
    gui: false,
    ip: DEFAULT_IP.to_s,
    cpus: 2,
    hostname: 'phalconbox.localhost',
    natdnshostresolver: 'on',
    natdnsproxy: 'on',
    verbose: false
  }.freeze

  def initialize
    initialize_defaults
  end

  private

  def initialize_defaults
    @settings = DEFAULT_SETTINGS.merge(load_file)

    memory = setup_memory
    memory = 1024 if memory.to_i < 1024

    settings[:memory] = memory
    settings[:cpus] = setup_cpu
  end

  def load_file
    file = './settings.yml'

    if File.exist? file
      opts = YAML.safe_load(File.read(file)) || {}
    else
      opts = {}
    end

    symbolize(opts)
  end

  def symbolize(obj)
    if obj.is_a? Hash
      obj.inject({}) { |memo, (k, v)| memo[k.to_sym] = symbolize(v); memo }
    elsif obj.is_a? Array
      obj.inject([]) { |memo, v| memo << symbolize(v); memo }
    else
      obj
    end
  end

  def setup_cpu
    return DEFAULT_CPUS unless settings[:cpus]

    settings[:cpus].to_i
  end

  def setup_memory
    return DEFAULT_MEMORY unless settings[:memory]

    settings[:memory].to_i
  end
end
