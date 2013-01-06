require 'forwardable'

# mixins
require 'hardworkingbob/chat_history'
require 'hardworkingbob/logging'
require 'hardworkingbob/utils'

# base classes
require 'hardworkingbob/server'

# classes
require 'hardworkingbob/cli'
require 'hardworkingbob/config'
require 'hardworkingbob/dispatch'
require 'hardworkingbob/lock'
require 'hardworkingbob/message'
require 'hardworkingbob/plugin'
require 'hardworkingbob/plugin_manager'
require 'hardworkingbob/skype'
require 'hardworkingbob/storage'

module HardworkingBob
  include Logging

  class << self
    extend Forwardable

    def run(argv)
      if argv.include?('--debug')
        Logger.level = ::Logger::DEBUG
      end

      if argv.include?('--cli')
        Config.server = Cli.new
      end

      Config.server.start

    rescue => ex
      fatal "#{ex}"

      ex.backtrace.map do |line|
        debug "#{line}"
      end

      exit 1
    end
  end
end
