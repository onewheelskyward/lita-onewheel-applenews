require 'spec_helper'

def mock_up(filename)
  mock = File.open("spec/fixtures/#{filename}.html").read
  allow(RestClient).to receive(:get) { mock }
end

describe Lita::Handlers::OnewheelApplenews, lita_handler: true do
  it 'cocks about' do
    mock_up 'fil'
    send_message 'https://apple.news/ALjDjYg-3QKuFStFxUMRpZA'
    expect(replies.last).to include('https://www.cnn.com/2021/05/03/tech/bill-and-melinda-gates-divorce/index.html')
  end
end
