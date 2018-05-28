require 'spec_helper'

RSpec.describe 'Kryptono integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:eos_btc_pair) { Cryptoexchange::Models::MarketPair.new(base: 'BTC', target: 'KNOW', market: 'kryptono') }

  it 'fetch pairs' do
    pairs = client.pairs('kryptono')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'kryptono'
  end

  it 'fetch ticker' do
    ticker = client.ticker(eos_btc_pair)

    expect(ticker.base).to eq 'BTC'
    expect(ticker.target).to eq 'KNOW'
    expect(ticker.market).to eq 'kryptono'
    expect(ticker.last).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be_a Numeric
    expect(2000..Date.today.year).to include(Time.at(ticker.timestamp).year)
    expect(ticker.payload).to_not be nil
  end

  it 'fetch order book' do
    order_book = client.order_book(eos_btc_pair)

    expect(order_book.base).to eq 'BTC'
    expect(order_book.target).to eq 'KNOW'
    expect(order_book.market).to eq 'kryptono'
    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be nil
    expect(order_book.bids.first.amount).to_not be nil
    expect(order_book.bids.first.timestamp).to be nil
    expect(order_book.asks.count).to_not be nil
    expect(order_book.bids.count).to_not be nil
    expect(order_book.timestamp).to be_a Numeric
    expect(order_book.payload).to_not be nil
  end

  it 'fetch trade' do
    trades = client.trades(eos_btc_pair)
    trade = trades.sample

    expect(trades).to_not be_empty
    expect(trade.base).to eq 'BTC'
    expect(trade.target).to eq 'KNOW'
    expect(trade.trade_id).to_not be nil
    expect(trade.price).to_not be nil
    expect(trade.amount).to_not be nil
    expect(trade.timestamp).to be_a Numeric
    expect(trade.payload).to_not be nil
    expect(trade.market).to eq 'kryptono'
  end
end