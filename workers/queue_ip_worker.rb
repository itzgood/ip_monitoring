class QueueIpWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'queue_ips'

  def perform
    Ip.enabled.find_each do |ip|
      PingWorker.perform_async(ip.id)
    end
  end
end
