class Ip < ActiveRecord::Base
  has_many :pings, dependent: :destroy

  scope :enabled, -> { where(enabled: true) }

  def ping(icmp_client = IcmpClient)
    result = icmp_client.ping(address)

    pings.create(
      success: result.success,
      rtt: result.rtt
    )
  end

  def stats(time_from, time_to)
    result = ActiveRecord::Base.connection.execute(<<-SQL).first
    SELECT
      COUNT(*) AS total_pings,
      COUNT(CASE WHEN success = FALSE THEN 1 END) AS failed_pings,
      AVG(CASE WHEN success THEN rtt END) AS average_rtt,
      MIN(CASE WHEN success THEN rtt END) AS min_rtt,
      MAX(CASE WHEN success THEN rtt END) AS max_rtt,
      PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rtt) FILTER (WHERE success) AS median_rtt,
      STDDEV_POP(rtt) FILTER (WHERE success) AS standard_deviation
    FROM pings
    WHERE created_at BETWEEN '#{time_from}' AND '#{time_to}'
    AND ip_id = #{id}
    SQL

    return { error: 'No data available for the given period.' } if result['total_pings'].zero?

    {
      average_rtt: result['average_rtt'],
      min_rtt: result['min_rtt'],
      max_rtt: result['max_rtt'],
      median_rtt: result['median_rtt'],
      standard_deviation: result['standard_deviation'],
      packet_loss: (result['failed_pings'] / result['total_pings'].to_f) * 100
    }
  end
end
