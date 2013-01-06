module HardworkingBob
  class Dispatch
    include Logging

    def initialize
      PluginManager.load_plugins
    end

    def dispatch_message(msg)
      debug "Dispatcher received message #{msg.inspect}"
      return nil unless msg && msg.text != ''
      PluginManager.plugins.each do |p|
        debug "Dispatching to plugin : #{p.class}"
        if reply = p.triggered?(msg)
          info "#{p.class} triggered"
          return ensure_valid(reply)
        end
      end
      nil
    end


      private


      # dispatching must return a Message or nil, anything else will
      # cause errors.
      def ensure_valid(obj)
        return obj if obj.nil? || obj.is_a?(Message)

        error "invalid object <#{obj}>, expected Message or nil"

        nil
      end

  end
end
