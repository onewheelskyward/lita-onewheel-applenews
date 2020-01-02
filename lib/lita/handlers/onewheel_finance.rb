require 'rest-client'

class Colors
  prefix = "\x03"
  @white  = "#{prefix}00"
  @black  = "#{prefix}01"
  @blue   = "#{prefix}02"
  @green  = "#{prefix}03"
  @red    = "#{prefix}04"
  @brown  = "#{prefix}05"
  @purple = "#{prefix}06"
  @orange = "#{prefix}07"
  @yellow = "#{prefix}08"
  @lime   = "#{prefix}09"
  @teal   = "#{prefix}10"
  @aqua   = "#{prefix}11"
  @royal  = "#{prefix}12"
  @pink   = "#{prefix}13"
  @grey   = "#{prefix}14"
  @silver = "#{prefix}15"
  @reset  = prefix

  class << self
    attr_reader :white, :black, :blue, :green, :red, :brown, :purple, :orange, :yellow, :lime, :teal, :aqua, :royal, :pink, :grey, :silver, :reset
  end

  def initialize
  end
end

class GlobalQuote
  attr_reader :symbol, :open, :high, :low, :price, :volume, :trading_day, :prev_close, :change, :change_percent

  def initialize(json_blob)
    Lita.logger.debug "parsing: #{json_blob}"
    hash = JSON.parse(json_blob)
    quote = hash["Global Quote"]

    quote.keys.each do |key|
      case key
      when "01. symbol"
        @symbol = quote[key]
      when "02. open"
        @open = self.fix_price quote[key]
      when "03. high"
        @high = self.fix_price quote[key]
      when "04. low"
        @low = self.fix_price quote[key]
      when "05. price"
        @price = self.fix_price quote[key]
      when "06. volume"
        @volume = quote[key]
      when "07. latest trading day"
        @trading_day = quote[key]
      when "08. previous close"
        @prev_close = self.fix_price quote[key]
      when "09. change"
        @change = self.fix_price quote[key]
      when "10. change percent"
        @change_percent = quote[key]
      end
    end
  end

  def fix_price(price_str)
    price_str.to_f.round(2)
  end
end

module Lita
  module Handlers
    class OnewheelFinance < Handler
      config :apikey, required: true
      route /quote\s+(\w+)/i, :handle_quote, command: true

      def handle_quote(response)
        url = "https://www.alphavantage.co/query"
        resp = RestClient.get url, {function: 'GLOBAL_QUOTE', symbol: response.matches[0][0], apikey: config.apikey}
        stock = GlobalQuote.new resp
        str = "#{stock.symbol}: $#{stock.price} "
        if stock.change >= 0
          # if irc
          str += "#{Colors::green} ⇡#{stock.change}#{Colors::reset}, #{Colors::green}#{stock.change_percent}#{Colors::reset} "
        end
        response.reply str
      end

      Lita.register_handler(self)
    end
  end
end
