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
    puts replies.last
    expect(replies.last).to include('NASDAQ - LULU: $233.01')
  end

  it 'quotes down' do
    mock_up 'worldtradedata-quote-down'
    send_command 'quote xlp'
    puts replies.last
    expect(replies.last).to include('NYSE - XLP: $62.51')
    expect(replies.last).to include('↯$-0.47')
  end
end
