module Jobs
  class Base
    def self.schedule(with:, wait_until:)
      PendingJob.create(
        klass: self.to_s,
        params: with.to_json,
        wait_until: wait_until,
      )
    end

    def self.perform(params, id = nil)
      @client ||= Aws::SNS::Client.new
      @client.publish(
        topic_arn: '[Your SNS ARN]',
        message: {
          id: id,
          klass: self.to_s,
          params: params.to_json,
        }.to_json,
      )
    end
  end
end
