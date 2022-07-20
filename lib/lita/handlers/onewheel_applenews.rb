require 'rest-client'

module Lita
  module Handlers
    class OnewheelApplenews < Handler
      route /(http.*apple.news\/[^\s]+)/i, :handle_applenews
      route /(http.*stocks.apple.com\/[^\s]+)/i, :handle_applenews

      def handle_applenews(response)
        Lita.logger.info("Fetching #{response.matches[0][0]}")
        resp = RestClient.get(response.matches[0][0])
        url = ''

        if m = /redirectToUrlAfterTimeout\(\"(.*)\"/.match(resp)
          url = m[1]
        end

        response.reply url
      end

      Lita.register_handler(self)
    end
  end
end
