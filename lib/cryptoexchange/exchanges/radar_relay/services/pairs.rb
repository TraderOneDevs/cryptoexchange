module Cryptoexchange::Exchanges
  module RadarRelay
    module Services
      class Pairs < Cryptoexchange::Services::Pairs
        PAIRS_URL = "#{Cryptoexchange::Exchanges::RadarRelay::Market::API_URL}/markets"

        def fetch
          outputs = []
          (1..25).each do |page_id|
            pair_url = PAIRS_URL + "?page=#{page_id}&perPage=100"
            puts pair_url
            output = fetch_via_api(pair_url)
            break if output.empty?
            outputs = outputs + output
          end
          adapt(outputs)
        end

        def adapt(output)
          output.map do |ticker|
            base, target = ticker['displayName'].split('/')
            Cryptoexchange::Models::MarketPair.new({
              base: base,
              target: target,
              market: RadarRelay::Market::NAME
            })
          end
        end
      end
    end
  end
end
