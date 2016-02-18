require "lounger/version"

class Lounger
  def initialize
    @lock      = Mutex.new
    @condition = ConditionVariable.new

    Signal.trap("INT")  { wakeup! }
    Signal.trap("TERM") { wakeup! }
    Signal.trap("EXIT") { wakeup! }
    Signal.trap("USR1") { wakeup! }
    Signal.trap("QUIT") { wakeup! }
  end

  def idle
    @lock.synchronize { @condition.wait(@lock) }
  end

  def wakeup!
    @condition.signal
  end

  def self.idle
    Lounger.new.idle
  end
end