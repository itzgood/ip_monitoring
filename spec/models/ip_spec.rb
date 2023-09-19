require 'spec_helper'

RSpec.describe Ip do
  describe '#ping' do
    subject(:ping) { ip.ping(icmp_client) }

    let(:ip) { described_class.create address: '1.1.1.1' }
    let(:icmp_client) { class_double IcmpClient }
    let(:icmp_instance) { instance_double IcmpClient, **attrs }

    before do
      allow(icmp_client).to receive(:ping).with(ip.address)
        .and_return(icmp_instance)
    end

    context 'success' do
      let(:attrs) { { success: true, rtt: 100.0 } }

      it { expect(ping).to be_a Ping }
      it { expect(ping.success).to eq true }
      it { expect(ping.rtt).to eq 100.0 }
    end

    context 'failure' do
      let(:attrs) { { success: false, rtt: nil } }

      it { expect(ping).to be_a Ping }
      it { expect(ping.success).to eq false }
      it { expect(ping.rtt).to be_nil }
    end
  end

  describe '#stats' do
    let(:ip) { Ip.create(address: '8.8.8.8', enabled: true) }

    context 'when there is data' do
      before do
        3.times do |i|
          ip.pings.create(rtt: i + 1, success: true, created_at: Time.now.utc - (i+1).hours)
        end

        2.times do |i|
          ip.pings.create(rtt: nil, success: false, created_at: Time.now.utc - (i+1).hours)
        end
      end

      it 'returns correct statistics' do
        stats = ip.stats(Time.now.utc - 4.hours, Time.now)

        expect(stats[:average_rtt]).to eq(2) # (1+2+3) / 3
        expect(stats[:min_rtt]).to eq(1)
        expect(stats[:max_rtt]).to eq(3)
        expect(stats[:median_rtt]).to eq(2)
        expect(stats[:packet_loss]).to eq(40) # 2 failed out of 5 total
      end
    end

    context 'when there is no data' do
      it 'returns an error' do
        stats = ip.stats(Time.now - 4.hours, Time.now)
        expect(stats).to eq(error: 'No data available for the given period.')
      end
    end
  end
end
