require "spec_helper"

def mock_up(filename)
  mock = File.open("spec/fixtures/#{filename}.json").read
  allow(RestClient).to receive(:get) { mock }
end

describe Lita::Handlers::OnewheelFinance, lita_handler: true do
  #it 'feds' do
  #
  #end

  it 'quotes up' do
    mock_up 'worldtradedata-quote-up'
    send_command 'quote lulu'
    expect(replies.last).to include("\u000314NASDAQ - \u0003LULU: \u000302$233.01\u0003")
    expect(replies.last).to include('(Lululemon Athletica Inc.)')
  end

  it 'quotes down' do
    mock_up 'worldtradedata-quote-down'
    send_command 'quote xlp'
    expect(replies.last).to include("\u000314NYSE - \u0003XLP: \u000302$62.51\u0003")
    expect(replies.last).to include('↯$-0.47')
    expect(replies.last).to include('(Consumer Staples Select Sector SPDR Fund)')
  end

  it 'nasdaq:lulu' do
    mock_up 'worldtradedata-quote-up'
    send_command 'q nasdaq:lulu'
    expect(replies.last).to include("\u000314NASDAQ - \u0003LULU: \u000302$233.01\u0003")
  end

  it 'removes $ from ^ reqs' do
    mock_up 'worldtradedata-quote-dji'
    send_command 'q ^dji'
    expect(replies.last).to include("\u000314INDEXDJX - \u0003^DJI: \u00030225766.64\u0003 \u000304 ↯-1190.95\u0003, \u000304-4.42%\u0003 \u000314(Dow Jones Industrial Average)\u0003")
  end

  #it 'errors' do
  #  mock_up 'worldtradedata-error'
  #  send_command 'quote in'
  #  expect(replies.last).to eq('`in` not found on any stock exchange.')
  #end


  # This doesn't exist
  #it 'TADAWUL:2222' do
  #  mock_up 'worldtradedata-TADAWUL-2222.json'
  #
  #end
  #it 'searches with 1 result' do
  #  mock_up 'worldtradedata-search-1'
  #  send_command 'quote nike'
  #  expect(replies.last).to eq('NKE')
  #end
end
