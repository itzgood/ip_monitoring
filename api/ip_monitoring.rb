class IpMonitoring < Sinatra::Base
  post '/ips' do
    ip = Ip.create(address: params[:ip], enabled: params[:enabled])
    ip.to_json
  end

  post '/ips/:id/enable' do
    ip = Ip.find(params[:id])
    ip.update(enabled: true)
    ip.to_json
  end

  post '/ips/:id/disable' do
    ip = Ip.find(params[:id])
    ip.update(enabled: false)
    ip.to_json
  end

  get '/ips/:id/stats' do
    ip = Ip.find(params[:id])
    stats = ip.stats(params[:time_from], params[:time_to])
    stats.to_json
  end

  delete '/ips/:id' do
    ip = Ip.find(params[:id])
    ip.destroy
    { success: true }.to_json
  end
end
