class AdjustedBankTransaction
  require 'csv'
  def initialize(file, filename)
    @file = file
    @filename = filename
  end

  def call
		file_contents = @file.readlines.map(&:chomp)
    total = file_contents.delete_at(file_contents.length - 1)
    amount = 0

    file_contents.each do |element|
      if element.include?("GCP")
        match = element.match(/^(.*?)(\d+[,.]\d+)$/)
        description = match[1].strip
        amount = amount + match[2].gsub(',', '').to_f
      end
    end
    file_contents << "mechanincal business transoformation GCP - consolidated,#{amount}"
    file_contents << "mechanincal business transoformation GCP - consolidated,#{amount * -1}"
    file_contents << "Total,#{total}"
    
    CSV.open("received_files/adjusted_#{@filename}.csv", "wb") do |csv|
      file_contents.each do |row|
        csv << row.split("\n")
      end
    end

    file_contents.to_json
  end
end
