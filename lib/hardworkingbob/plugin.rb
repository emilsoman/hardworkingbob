module HardworkingBob
  # The plugin class is used to encapsulate triggered actions.
  class Plugin
    include Utils
    include ChatHistory
    include Logging

    def self.inherited(klass)
      debug "#{klass} plugin loaded"
      PluginManager.add(klass.new)
    end

    attr_accessor :description


    #If plugin could understand the message
    #send back the reply
    def triggered?(msg)
      if understood?(msg)
        return reply
      end
      nil
    end

  end
end
