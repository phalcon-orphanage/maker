# -*- mode: ruby -*-
# frozen_string_literal: true

# Configure provider
class Provider
  SUPPORTED_PROVIDERS = %i(vmware_desktop vmware_fusion vmware_workstation virtualbox).freeze

  attr_accessor :current

  def initialize
    current = detect_provider
    validate current

    ENV['VAGRANT_DEFAULT_PROVIDER'] = current.to_s
    @current = current
  end

  private

  # Workaround for mitchellh/vagrant#1867
  def detect_provider
    if ARGV[1] and (ARGV[1].split('=')[0] == '--provider' or ARGV[2])
      return (ARGV[1].split('=')[1] || ARGV[2]).to_sym
    end

    (ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym
  end

  def validate(current)
    return if SUPPORTED_PROVIDERS.include? current

    abort("Unsupported provider: #{current}")
  end
end
