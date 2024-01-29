# frozen_string_literal: true

require 'lounger/version'

# The Lounger class is the main class which will allow to handle traps
# in simple way.
class Lounger
  SIGNALS = %w[INT TERM EXIT USR1 QUIT].freeze

  def initialize(include_signals: [], exclude_signals: [])
    @lock            = Mutex.new
    @condition       = ConditionVariable.new
    @pending_signals = 0
    @buffer          = []
    @idle            = false

    (SIGNALS + include_signals - exclude_signals).each do |s|
      Signal.trap(s) { @condition.signal }
    end
  end

  def idle(ignore_pending: false)
    result = nil
    @lock.synchronize do
      @pending_signals = 0 if ignore_pending
      @idle = true

      if @pending_signals.positive?
        @pending_signals -= 1
      else
        @condition.wait(@lock)
        @pending_signals -= 1
      end

      @idle = false
      result = @buffer.shift
    end

    result
  end

  def idle?
    @idle
  end

  def wakeup!(value = nil)
    @lock.synchronize do
      @pending_signals += 1
      @buffer << value
      @condition.signal
    end
  end

  def self.idle
    Lounger.new.idle
  end

  alias_method :waiting?, :idle?
  alias_method :wait, :idle
  alias_method :signal, :wakeup!
end
