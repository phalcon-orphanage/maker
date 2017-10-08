# -*- mode: ruby -*-
# frozen_string_literal: true

# Configure custom ports
class Ports
  # Default port forwarding
  DEFAULT_PORTS = [
    { guest: 80,     host: 8000 },
    { guest: 3306,   host: 33_060 },
    { guest: 5432,   host: 54_320 },
    { guest: 35_729, host: 35_729 }
  ].freeze

  attr_accessor :config, :settings

  def initialize(config, settings)
    @config = config
    @settings = settings

    standardize
  end

  # Use default port forwarding
  def configure
    unless settings[:default_ports] && settings[:default_ports] == false
      DEFAULT_PORTS.each do |ports|
        unless settings[:ports].any? { |m| m[:guest] == ports[:guest] }
          config.vm.network :forwarded_port,
                            guest: ports[:guest],
                            host_ip: '127.0.0.1',
                            host: ports[:host],
                            auto_correct: true
        end
      end
    end
  end

  private

  # Standardize ports naming schema
  def standardize
    if settings[:ports]
      settings[:ports].each do |port|
        port[:guest] ||= port[:to].to_i
        port[:host] ||= port[:send].to_i
        port[:protocol] ||= 'tcp'
      end
    else
      settings[:ports] = []
    end
  end
end
