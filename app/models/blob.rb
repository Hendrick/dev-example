# frozen_string_literal: true

class Blob
  def self.create_description_file(uuid, updated_content)
    File.open('received_files/data/description.json', 'a') do |_file|
      existing_data = if File.zero?('received_files/data/description.json')
                        []
                      else
                        JSON.parse(File.read('received_files/data/description.json'))
                      end

      new_data = { "id": uuid, "filename": updated_content['filename'] }

      existing_data << new_data

      json_str = JSON.pretty_generate(existing_data)

      File.write('received_files/data/description.json', json_str)
    end
  end

  def self.manipulate_file_content(file_content)
    content = JSON.parse(file_content)
    decoded_string = Base64.decode64(content['file'])
    lines = decoded_string.split("\n")
    transactions = []
    consolidated_amount = 0.0

    lines.each do |line|
      parts = line.split(',')
      description = parts[0]
      amount = parts[1].to_f

      if description.include?('mechanincal business transoformation GCP')
        consolidated_amount += amount
      else
        transactions << { description:, amount: }
      end
    end

    last_information = []

    if consolidated_amount != 0.0
      last_information << { description: 'consolidated mechanical business transformation GCP',
                            amount: consolidated_amount }
      last_information << { description: 'offset consolidated mechanical business transformation GCP',
                            amount: -consolidated_amount }
    end

    last_information_string = last_information.map { |t| "#{t[:description]},#{'%.2f' % t[:amount]}" }.join("\r\n")
    total_amount = transactions.map { |t| t[:amount] }.sum
    transactions << { description: 'Total', amount: total_amount }

    removed_total = lines.pop
    new_lines = lines.join("\n")

    total_transactions = "#{new_lines}\n#{last_information_string}\n#{removed_total}"

    content['file'] = Base64.encode64(total_transactions)
    content
  end
end
