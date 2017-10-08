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

  attr_accessor :config

  def initialize(config)
    @config = config
  end

  # Use default port forwarding
  def configure
    DEFAULT_PORTS.each do |ports|
      config.vm.network :forwarded_port,
                        guest: ports[:guest],
                        host_ip: '127.0.0.1',
                        host: ports[:host],
                        auto_correct: true
    end
  end
end
