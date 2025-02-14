
class ExternalMessengerService

  BOT_ADA = AppConfig.telegram_bots.ada

  def initialize(token = BOT_ADA[:token], chat_id = BOT_ADA[:chat_id])
    @token   = token
    @chat_id = chat_id
  end

  def send_demo_messenge(message)
    bot = Telegram::Bot::Client.new(@token)
    bot.send_message(chat_id: @chat_id, text: message)
  end



end