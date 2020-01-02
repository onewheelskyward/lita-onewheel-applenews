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
    mock_up 'alphavantage-global-quote'
    send_command 'quote lulu'
    puts replies.last
    expect(replies.last).to include('LULU: $230.83')
  end

  it 'quotes down' do
    mock_up 'alphavantage-quote-down'
    send_command 'quote clb'
    puts replies.last
    expect(replies.last).to include('CLB: $37.67')
    expect(replies.last).to include('$-9.79')
  end
end
