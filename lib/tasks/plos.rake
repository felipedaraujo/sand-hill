require 'net/http'
require 'json'

$API_KEY = 'J-79dDhF4Uvx_UUxcJ_R'
$attrs = ['id', 'title', 'abstract', 'materials_and_methods', 'journal', 'publication_date']
$checkmark = "\u2713"
$documents = 101
$start = 0

desc 'Extract protocols from PLOS'
namespace :plos do
  task :extract => :environment do
    loop do
      query = "*&start=#{$start}&rows=100&fl=#{$attrs.join(',')}&wt=json&api_key=#{$API_KEY}"
      uri = URI("http://api.plos.org/search?q=#{query}")

      puts "\n=> starting from #{$start}"
      puts uri

      res = Net::HTTP.get_response(uri)

      if res.is_a?(Net::HTTPSuccess)
        $start += 100

        json = JSON.parse(res.body, symbolize_names: true)

        # $pages = json[:response][:numFound]
        save(json[:response][:docs])
      else
        puts 'bad request'
      end

      break if $start >= $documents
    end
  end
end

def save(protocols)
  for protocol in protocols do
    if keys?(protocol, $attrs)
      Protocol.create(params(protocol, $attrs))

      puts "#{$checkmark.encode('utf-8')} #{Protocol.last[:title]}"
    end
  end
end

def keys?(hash, attrs)
  attrs.all? { |attr| hash.key?(attr.to_sym) }
end

def params(obj, attrs)
  params = {}

  attrs.map do |attr|
    key = attr == 'id' ? :journal_id : attr.to_sym
    params[key] = obj[attr.to_sym].is_a?(Array) ? obj[attr.to_sym].first : obj[attr.to_sym]
  end

  params
end
