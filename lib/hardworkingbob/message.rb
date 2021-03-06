module HardworkingBob
  # The main basil data type: the Message. Servers should construct
  # these and pass them through dispatch which will also return a
  # Message if a response is triggered.
  class Message
    attr_reader :to, :from, :from_name, :time, :text
    attr_accessor :chat

    def initialize(to, from, from_name, text, chat = nil)
      @time = Time.now
      @to, @from, @from_name, @text, @chat = to, from, from_name, text, chat
    end

    # Is this message to my configured nick?
    def to_me?
      to.downcase == Config.me.downcase
    rescue
      false
    end

    # avoiding #to_s to preserve #inspect, see
    # http://bugs.ruby-lang.org/issues/4453.
    def pretty
      "(#{chat}) #{to || 'n/a'}: #{text.slice(0..20)}..."
    end
  end
end
