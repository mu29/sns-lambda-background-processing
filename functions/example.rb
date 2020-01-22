require_relative '../config/environment'

def handler(event:, context:)
  params = JSON.parse(event['body']).symbolize_keys rescue {}

  if params[:wait_until]
    Jobs::SendEmail.schedule(
      with: {
        to: params[:to],
        subject: params[:subject],
        body: params[:body],
      },
      wait_until: wait_until
    )
  else
    Jobs::SendEmail.perform(
      to: params[:to],
      subject: params[:subject],
      body: params[:body],
    )
  end

  { statusCode: 204 }
end
