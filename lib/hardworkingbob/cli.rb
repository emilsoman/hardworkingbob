module HardworkingBob
  class Cli < Server
    has_command(:quit) do |*args|
      exit 0
    end

    def start
      info "starting cli server"

      super

      loop do
        print '> '; str = $stdin.gets.chomp
        msg = Message.new(Config.me, ENV['USER'], ENV['USER'], str, 'cli')

        if reply = dispatch_message(msg)
          info "sending #{reply.pretty}"
          puts reply.text
        end
      end
    end
  end
end
