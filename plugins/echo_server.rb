class Echo < HardworkingBob::Plugin

  def initialize
    @desciption = "Test echo server"
  end

  def understood?(message)
    @message = message
    return true
  end

  def reply
    @message
  end

end
