class TestWorkerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    messenge = "This is periodic test, --(#{ Time.now.strftime('%Y/%m/%d %I:%M %p')})"
    service = ExternalMessengerService.new
    service.send_normal_messenge(messenge)

  end
end
