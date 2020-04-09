class WorldTradeDataQuote
  attr_reader :open, :high, :low, :price, :volume, :trading_day, :prev_close, :change, :change_percent, :exchange, :error, :name, :message, :is_index
  attr_accessor :symbol

  def initialize(symbol, api_key)
    @base_uri = 'https://api.worldtradingdata.com/api/v1'
    @symbol = symbol
    @api_key = api_key

    if @symbol[':']
      (@exchange, @symbol) = @symbol.split /:/
    end

    if @symbol['^']
      @is_index = true
    else
      @is_index = false
    end

    self.call_api

    hash = JSON.parse(@response)

    # We couldn't find the stock.  Let's look for it real quick.
    if hash['Message'].to_s.include? 'Error'
      @error = true
      self.run_search

      if @message
        @error = true
        return
      else
        self.call_api
        hash = JSON.parse(@response)
        @error = false
      end
    else
      @error = false
    end

    unless hash['data']
      @message = "Error getting data for #{@symbol}"
      @error = true
      return
    end

    quote = hash['data'][0]

    quote.keys.each do |key|
      case key
      when "symbol"
        @symbol = quote[key]
      when "price_open"
        @open = self.fix_number quote[key]
      when "day_high"
        @high = self.fix_number quote[key]
      when "day_low"
        @low = self.fix_number quote[key]
      when "price"
        @price = self.fix_number quote[key]
      when "volume"
        @volume = quote[key].to_i
      when "last_trade_time"
        @trading_day = quote[key]
      when "08. previous close"
        @prev_close = self.fix_number quote[key]
      when "day_change"
        @change = self.fix_number quote[key]
      when "change_pct"
        @change_percent = self.fix_number quote[key]
      when 'stock_exchange_short'
        @exchange = quote[key].sub /NYSEARCA/, 'NYSE'
      when 'name'
        @name = quote[key]
      end
    end

    def is_index?
      is_index
    end
  end

  # Let's see what we can get from the api.
  def call_api
    url = "#{@base_uri}/stock"
    params = {symbol: @symbol, api_token: @api_key}

    if @exchange
      params[:stock_exchange] = @exchange
    end

    Lita.logger.debug "call_api: #{url} #{params.inspect}"

    @response = RestClient.get url, {params: params}

    Lita.logger.debug "response: #{@response}"
  end

  def run_search
    url = "#{@base_uri}/stock_search"
    params = {search_term: @symbol,
              search_by: 'symbol,name',
              stock_exchange: 'NASDAQ,NYSE',
              limit: 5,
              page: 1,
              api_token: @api_key
    }

    Lita.logger.debug "run_search: #{url} #{params.inspect}"

    response = RestClient.get url, {params: params}

    Lita.logger.debug "response: #{response}"
    result = JSON.parse(response)

    if result['total_returned'] == 1
      @symbol = result['data'][0]['symbol']
    elsif result['total_returned'].to_i > 1
      Lita.logger.debug "many search results: #{result.inspect}"
      x = result['data'].map { |k| k.values[0] }
      @message = "`#{symbol}` not found, did you mean one of #{x.join(', ')}?"
    end
  end

  def fix_number(price_str)
    price_str.to_f.round(2)
  end
end
