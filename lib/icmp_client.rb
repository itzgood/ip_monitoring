require 'net/ping'
require 'ostruct'

class IcmpClient
  PORT = nil
  TIMEOUT = 1

  def self.ping(ip_address)
    new(ip_address)
  end

  attr_reader :success, :rtt

  def initialize(ip_address, icmp_lib: Net::Ping::External)
    pinger = icmp_lib.new(ip_address, PORT, TIMEOUT)
    @success = pinger.ping
    @rtt = success ? (pinger.duration * 1000) : nil
  end
end
