class MessageComponent < ViewComponent::Base
  def initialize(message)
    @common_message = message
  end

  def common_message_title
    @common_message[:title]
  end

  def common_message_content
    @common_message[:content]
  end

  def message_icon_status
    case @common_message[:title]
    when "Notice"
      "bi bi-info-circle-fill"
    when "Alert"
      "bi bi-exclamation-triangle-fill"
    when "Error"
      "bi bi-bug-fill"
    end
  end

end