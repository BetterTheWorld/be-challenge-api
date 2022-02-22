class TransactionGenerator
  attr_reader :name, :format, :transactions
  class < self
    def generate_report(name, format).generate_report
      TransactionGenerator.new(name, format)
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
    @created_at ||= rand(43200..259200).seconds.ago
  end

  def placed_at
    @placed_at ||= (created_at  + rand(120..7200).seconds)
  end

  def paid_at
    return nil if status == 'pending'
    @placed_at ||=  (created_at  + rand(120..7200).seconds)
  end

  def status
    @status ||= rand > 0.8 ? 'pending' : 'paid'
  end

  def extras
    case @format
    when :json
      id = rand(1000..3333)
      {
        items: [{sku: 101, name: 'Standard Clones', units: rand(10000..50000)}, {sku: 666, name: 'Elite Clone', units: rand(100..3000)}],
        delivery_notes: 'No delivery schedule',
        account: {id: id, email: "#{id}@galacticsenate.com" } 
      }
    when :csv
      {
        order_details: "#{rand(6..12)}xMC30C,#{rand(2..6)}xMC-SC,#{rand(1..2)}xViscountClass",
        account_number: rand(3334..6666),
        account_name: 'Alderaan League',
        account_contact: 'l.organa@alderaan_diplomatic.corps.com'
      }
    when :xml
      {
        manifest: 'REDACTED',
        shipping: 'Curbside pickup',
        client_id: SecureRandom.hex,
        client_name: 'REDACTED'
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
    
  end

  def save_to_csv
    
  end

  def save_to_xml
  end
end