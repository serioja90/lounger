require "lounger/version"

class Lounger
  SIGNALS = ["INT", "TERM", "EXIT", "USR1", "QUIT"]

  def initialize(include_signals: [], exclude_signals: [])
    @lock      = Mutex.new
    @condition = ConditionVariable.new

    (SIGNALS + include_signals - exclude_signals).each do |signal|
      Signal.trap(signal) { wakeup! }
    end
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

  alias_method :wait, :idle
  alias_method :signal, :wakeup!
end