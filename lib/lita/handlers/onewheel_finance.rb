require_relative 'irc_colors'
require_relative 'alphavantage_quote'
require_relative 'worldtradedata_quote'
require_relative 'yahoo_quote'
require 'rest-client'

module Lita
  module Handlers
    class OnewheelFinance < Handler
      config :apikey, required: true
      config :handler, default: 'alphavantage'
      route /qu*o*t*e*\s+(.+)/i, :handle_quote, command: true
      # route /q2\s+(.+)/i, :handle_alphavantage, command: true

      def handle_quote(response)
        stock = nil
        if config.handler == 'worldtradedata'
          stock = handle_world_trade_data response.matches[0][0]
        elsif config.handler == 'alphavantage'
          stock = handle_alphavantage response.matches[0][0]
        elsif config.handler == 'yahoo'
          stock = handle_yahoo response.matches[0][0]
        else
          Lita.logger.error "Unknown/missing config.handler #{config.handler}.  Try 'worldtradedata' or 'alphavantage'"
          return
        end

        # Continue!
        if stock.error
          if stock.message
            str = stock.message
          else
            str = "`#{stock.symbol}` not found on any stock exchange."
          end
        else
          dollar_sign = '$'
          if stock.is_index?
            dollar_sign = ''
          end

          str = "#{IrcColors::grey}#{stock.exchange} - #{IrcColors::reset}#{stock.symbol}: #{IrcColors::blue}#{dollar_sign}#{stock.price}#{IrcColors::reset} "
          if stock.change >= 0
            # if irc
            str += "#{IrcColors::green} ⬆#{dollar_sign}#{stock.change}#{IrcColors::reset}, #{IrcColors::green}#{stock.change_percent}%#{IrcColors::reset} "
            str += "#{IrcColors::grey}(#{stock.name})#{IrcColors::reset}"
          else
            str += "#{IrcColors::red} ↯#{dollar_sign}#{stock.change}#{IrcColors::reset}, #{IrcColors::red}#{stock.change_percent}%#{IrcColors::reset} "
            str += "#{IrcColors::grey}(#{stock.name})#{IrcColors::reset}"
          end
        end

        response.reply str
      end

      def handle_world_trade_data(symbol)
        stock = WorldTradeDataQuote.new symbol, config.apikey
        if stock.error
          stock.symbol = symbol
        end
        stock
      end

      # deprecated for now
      def handle_alphavantage(symbol)
       stock = AlphaVantageQuote.new symbol, config.apikey
      end

      # welp
      def handle_yahoo(symbol)
       stock = YahooQuote.new symbol, config.apikey
      end

      Lita.register_handler(self)
    end
  end
end
