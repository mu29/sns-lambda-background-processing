require_relative '../config/environment'

def handler(event:, context:)
  PendingJob.enqueued.each do |job|
    job.klass.constantize.perform(job.params, job.id)
  end
rescue => e
  logger = Logger.new(STDERR)
  logger.error e.inspect
end
