require_relative '../config/environment'

def handler(event:, context:)
  messages = event['Records'].map do |record|
    JSON.parse(record['Sns']['Message']).symbolize_keys
  end
  messages.each do |message|
    klass = message[:klass]
    params = message[:params]
    id = message[:id]&.to_i

    while params.is_a? String
      params = JSON.parse(params)
    end

    klass.constantize.new.execute(params.symbolize_keys)
    PendingJob.destroy(id) unless id.nil?
  end
rescue => e
  logger = Logger.new(STDERR)
  logger.error e.inspect
end
