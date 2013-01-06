module HardworkingBob
  class PluginManager
    include Logging

    class << self
    attr_accessor :plugins
    end

    def self.load_plugins
      @plugins = []
      dir = Config.plugins_directory

      if Dir.exists?(dir)
        debug "loading plugins from #{dir}"

        Dir.glob("#{dir}/*").sort.each do |f|
          begin load(f)
          rescue Exception => ex
            error "loading plugin #{f}: #{ex}"
            next
          end
        end
      end
    end

    def self.add(plugin)
      @plugins << plugin
    end

    def self.dispatch(message)
      @plugins.each do |plugin|
        plugin.dispatch(message)
      end
    end

  end
end
