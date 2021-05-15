require 'spec_helper'

def mock_up(filename)
  mock = File.open("spec/fixtures/#{filename}.json").read
  allow(RestClient).to receive(:get) { mock }
end

describe Lita::Handlers::OnewheelApplenews, lita_handler: true do
  it 'quotes up' do
    mock_up 'worldtradedata-quote-up'
    send_command 'quote lulu'
    expect(replies.last).to include("\u000314NASDAQ - \u0003LULU: \u000302$233.01\u0003")
    expect(replies.last).to include('(Lululemon Athletica Inc.)')
  end
end
