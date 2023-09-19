require 'spec_helper'

class TestSuccessIcmpLib
  def initialize(_ip_address, _port, _timeout); end

  def ping
    true
  end

  def duration
    0.010249
  end
end

class TestFailureIcmpLib
  def initialize(_ip_address, _port, _timeout); end

  def ping
    false
  end
end

RSpec.describe IcmpClient do
  context 'when success ping' do
    subject(:ping) do
      described_class.new(
        '1.1.1.1',
        icmp_lib: TestSuccessIcmpLib
      )
    end

    it { expect(ping.success).to eq true }
    it { expect(ping.rtt).to eq 10.248999999999999 }
  end

  context 'when failure ping' do
    subject(:ping) do
      described_class.new(
        '0.0.0.0',
        icmp_lib: TestFailureIcmpLib
      )
    end

    it { expect(ping.success).to eq false }
    it { expect(ping.rtt).to eq nil }
  end
end
