require 'fileutils'

CWD = File.dirname(__FILE__)
DEFAULT_PROVIDER = 'virtualbox'.freeze
DISTRO_RELEASE = 'ubuntu-16.04'.freeze

BANNER = "What provider do you want to use? (default: #{DEFAULT_PROVIDER}): "
         .freeze

task default: %w[all]

desc 'Build Vagrant Boxes'
task :build do
  provider = ask "\n#{BANNER}"
  provider ||= DEFAULT_PROVIDER

  build_image provider
end

def build_image(provider)
  log_file = "#{CWD}/logs/#{provider}-#{DISTRO_RELEASE}.log"

  run 'vagrant destroy -f'
  FileUtils.rm_rf('.vagrant')
  run "time vagrant up --provider=#{provider} 2>&1 | tee #{log_file}"
  run 'vagrant halt'
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
