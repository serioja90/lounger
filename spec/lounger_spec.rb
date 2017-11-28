require 'spec_helper'

describe Lounger do

  it 'has a version number' do
    expect(Lounger::VERSION).not_to be nil
  end

  describe "instance" do
    subject(:lounger){ Lounger.new }

    it { is_expected.to respond_to :idle }
    it { is_expected.to respond_to :idle? }
    it { is_expected.to respond_to :wait }
    it { is_expected.to respond_to :waiting? }
    it { is_expected.to respond_to :signal }
    it { is_expected.to respond_to :wakeup! }

  end

  describe "#idle" do
    subject(:lounger) { Lounger.new }
    let(:thread) { Thread.new{ lounger.idle; sleep 1 } }
    let(:random_val) { rand }

    before do
      # call the thread variable for the first time, in order
      # to force its initialization
      thread

      loop do
        break if lounger.waiting?
        sleep 0.001
      end
    end

    it { is_expected.to be_waiting }
    it { is_expected.to be_idle }

    it 'should change thread status to "sleep"' do
      expect(thread.status).to eq("sleep")
    end

    it "should wakeup on signal" do
      lounger.signal
      expect(thread.status).to eq("run")
    end

    it "should receive value on signal" do
      l = Lounger.new
      result = nil
      t = Thread.new{ result = l.wait }
      l.signal random_val
      loop do
        break unless t.alive?
        sleep 0.001
      end
      expect(result).to eq(random_val)
    end

    it "should not be waiting if has already received the signal" do
      l = Lounger.new
      l.signal
      l.wait
      expect(l).not_to be_waiting
    end

    it "should preserve values of pending signals" do
      l = Lounger.new
      10.times{|i| l.signal i}

      10.times do |i|
        val = l.wait
        expect(val).to eq(i)
      end
    end
  end
end
