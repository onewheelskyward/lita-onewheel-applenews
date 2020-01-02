require "spec_helper"

def mock_up(filename)
  mock = File.open("spec/fixtures/#{filename}.json").read
  allow(RestClient).to receive(:get) { mock }
end

describe Lita::Handlers::OnewheelFinance, lita_handler: true do
  #it 'feds' do
  #
  #end

  it 'quotes' do
    mock_up 'alphavantage-global-quote'
    send_command 'quote lulu'
    puts replies.last
    expect(replies.last).to include('LULU: $230.83')
  end
end
