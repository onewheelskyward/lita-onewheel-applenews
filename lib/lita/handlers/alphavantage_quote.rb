class AlphaVantageQuote
  attr_reader :open, :high, :low, :price, :volume, :trading_day, :prev_close, :change, :change_percent, :exchange, :error, :name, :message, :is_index
  attr_accessor :symbol

  def initialize(symbol, apikey)
    # Lita.logger.debug "parsing: #{json_blob}"
    # hash = JSON.parse(json_blob)
    @symbol = symbol
    @apikey = apikey
    @is_index = false

    if @symbol[0] == '^'
      @is_index = true
    end

    response = call_api
    hash = JSON.parse response

    quote = hash["Global Quote"]

    quote.keys.each do |key|
      case key
      when "01. symbol"
        @symbol = quote[key]
      when "02. open"
        @open = self.fix_number quote[key]
      when "03. high"
        @high = self.fix_number quote[key]
      when "04. low"
        @low = self.fix_number quote[key]
      when "05. price"
        @price = self.fix_number quote[key]
      when "06. volume"
        @volume = quote[key]
      when "07. latest trading day"
        @trading_day = quote[key]
      when "08. previous close"
        @prev_close = self.fix_number quote[key]
      when "09. change"
        @change = self.fix_number quote[key]
      when "10. change percent"
        @change_percent = self.fix_number quote[key]
      end
    end
  end

  def fix_number(price_str)
    price_str.to_f.round(2)
  end

  def is_index?
    @is_index
  end

  def call_api
    url = "https://www.alphavantage.co/query"
    params = {function: 'GLOBAL_QUOTE', symbol: @symbol, apikey: @apikey}
    Lita.logger.debug "#{url} #{params.inspect}"
    response = RestClient.get url, {params: params}

    # if @exchange
    #   params[:stock_exchange] = @exchange
    # end

    Lita.logger.debug "response: #{response}"
    response
  end
end
