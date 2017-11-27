require "lounger/version"

class Lounger
  SIGNALS = ["INT", "TERM", "EXIT", "USR1", "QUIT"]

  def initialize(include_signals: [], exclude_signals: [])
    @lock            = Mutex.new
    @condition       = ConditionVariable.new
    @pending_signals = 0

    (SIGNALS + include_signals - exclude_signals).each do |signal|
      Signal.trap(signal) { wakeup! }
    end
  end

  def idle(ignore_pending: false)
    @lock.synchronize do
      @pending_signals = 0 if ignore_pending

      if @pending_signals > 0
        @pending_signals -= 1
      else
        @condition.wait(@lock)
        @pending_signals -= 1
      end
    end
  end

  def wakeup!
    @lock.synchronize do
      @pending_signals += 1
      @condition.signal
    end
  end

  def self.idle
    Lounger.new.idle
  end

  alias_method :wait, :idle
  alias_method :signal, :wakeup!
end