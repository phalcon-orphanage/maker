# -*- mode: ruby -*-
# frozen_string_literal: true

# Register all of the configured shared folders
class Folders
  SYNCED_FOLDERS = [
    { map: './', to: '/vagrant' },
    { map: './ansible', to: '/ansible' },
  ].freeze

  attr_accessor :config

  def initialize(config)
    @config = config
  end

  def configure
    SYNCED_FOLDERS.each do |folder|
      from = File.expand_path(folder[:map])
      if File.exist? from
        user_folder(folder)
      else
        notify(from)
      end
    end
  end

  private

  def user_folder(folder)
    options = merge_and_symbolize(folder)

    config.vm.synced_folder folder[:map],
                            folder[:to],
                            type: folder[:type] ||= nil,
                            **options

    return unless Vagrant.has_plugin? 'vagrant-bindfs'
    config.bindfs.bind_folder folder[:to], folder[:to]
  end

  def notify(from)
    config.vm.provision :shell do |s|
      s.inline = <<-EOF
        >&2 echo "Unable to mount '$1' folder"
        >&2 echo "Please check your folders in settings.yml"
      EOF
      s.args = [from]
    end
  end

  def merge_and_symbolize(folder)
    mount_options = { mount_options: prepare_option(folder) }
    options = (folder[:options] || {}).merge(mount_options)

    options.keys.each { |k| options[k.to_sym] = options.delete(k) }

    options
  end

  def prepare_option(folder)
    if folder[:type] == 'nfs'
      folder[:options] || %w[actimeo=1 nolock]
    elsif folder[:type] == 'smb'
      folder[:options] || %w[vers=3.02 mfsymlinks]
    else
      []
    end
  end
end
