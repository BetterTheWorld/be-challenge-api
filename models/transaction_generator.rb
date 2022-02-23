require 'securerandom'
require 'time'
require 'json'
require 'csv'
require 'faker'
require "nokogiri"

class TransactionGenerator
  attr_reader :name, :format, :transactions
  class << self
    def generate_report(name, format)
      TransactionGenerator.new(name, format).generate_report
    end
  end

  def initialize(name, format)
    @name = name
    @format = format
    @transactions = []
  end

  def generate_report
    generate_transactions
    save_to_format
  end

  private

  def generate_transactions
    n = rand(20..30)
    bingo = rand(1..n-1)
    n.times do |i|
      transactions << generate_transaction( i==bingo )
      transactions << amended_transaction if i == bingo
    end
  end

  def generate_transaction(paid)
    @status = 'paid' if paid
    transaction = {
      id: SecureRandom.uuid,
      created_at: created_at,
      placed_at: placed_at,
      paid_at: paid_at,
      value: rand(10**4..10**7),
      status: status
    }
    transaction.merge(extras)
  end

  def amended_transaction
    transaction = transactions.last.dup
    transaction[:value] = (transaction[:value]*rand(0.33..0.85)).floor
    transaction[:status] = 'partial_refund'
    transaction
  end

  def created_at

    @created_at ||= time_plus_seconds(Time.now, -rand(43200..259200))
  end

  def placed_at
    @placed_at ||= time_plus_seconds(created_at, rand(120..7200))
  end

  def paid_at
    return nil if status == 'pending'
    @placed_at ||= time_plus_seconds(placed_at, rand(120..7200))
  end

  def status
    @status ||= rand > 0.8 ? 'pending' : 'paid'
  end

  def extras
    case @format
    when :json
      id = rand(1000..3333)
      {
        items: [{sku: 101, name: 'Standard Clones', units: rand(10..50)*1000}, {sku: 666, name: 'Elite Clone', units: rand(5..10)*100}],
        delivery_notes: 'No delivery scheduled',
        account: {id: id, email: "#{id}@galacticsenate.com", referrence_id: SecureRandom.hex} 
      }
    when :csv
      nom = Faker::Movies::StarWars.character
      {
        order_details: "#{rand(6..12)}xMC30C,#{rand(2..6)}xMC-SC,#{rand(1..2)}xViscountClass",
        account_number: rand(3334..6666),
        account_external_ref: SecureRandom.hex,
        account_name: nom,
        account_contact: "#{nom.gsub(' ', '_').gsub(/\W/, '')}@#{nom.split(' ').last.gsub(/\W/, '')}.com".downcase
      }
    when :xml
      {
        manifest: 'REDACTED',
        shipping: 'Curbside pickup',
        client_id: SecureRandom.hex,
        client_external_id: SecureRandom.hex,
        client_name: 'REDACTED',
        client_contact: 'REDACTED'
      }
    end
  end

  def save_to_format
    case @format
    when :json
      save_to_json
    when :csv
      save_to_csv
    when :xml
      save_to_xml
    end
  end

  def save_to_json
    File.write("./lib/#{name}.json", JSON.dump(transactions))
  end

  def save_to_csv
    CSV.open("./lib/#{name}.csv", "wb") do |csv|
      csv << transactions.first.keys.map {|k| k.to_s}
      transactions.each do |transaction|
        csv << transaction.values
      end
    end
  end

  def save_to_xml
  builder = Nokogiri::XML::Builder.new do |xml|
    xml.report {
      transactions.each do |transaction|
        xml.transaction {
          transaction.each_pair do |k,v|
            xml.send(k, v)
          end
        }
      end
    }
  end
  File.write("./lib/#{name}.xml", builder.to_xml)
  end

  def time_plus_seconds(time, seconds)
    Time.at(time.to_i + seconds) 
  end
end
TransactionGenerator.generate_report('kamino', :json)
TransactionGenerator.generate_report('mon_cala', :csv)
TransactionGenerator.generate_report('creed', :xml)
