class Jobs::SendEmail < Jobs::Base
  def execute(to:, subject:, body:)
    client = Aws::SES::Client.new(region: 'us-east-1')
    client.send_email({
      destination: {
        to_addresses: [to],
      },
      message: {
        subject: {
          charset: 'UTF-8',
          data: subject,
        },
        body: {
          html: {
            charset: 'UTF-8',
            data: body,
          },
        },
      },
      source: 'Injung Chung <mu29@yeoubi.net>',
    })
  end
end
