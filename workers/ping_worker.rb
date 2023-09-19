class PingWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'ping_ips'
  
  def perform(ip_id)
    ip = Ip.find(ip_id)
    ip.ping
  end
end
