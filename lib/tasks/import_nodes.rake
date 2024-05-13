require 'csv'

namespace :import do
  desc "Import nodes from a CSV file"
  task nodes: :environment do
    file_path = ENV['FILE_PATH']  # Expect a file path to be provided, e.g., FILE_PATH="data/nodes.csv"
    
    if file_path.blank?
      puts "ERROR: No FILE_PATH specified. Use `rake import:nodes FILE_PATH=path/to/file.csv`"
      next
    end

    unless File.exist?(file_path)
      puts "ERROR: File not found at #{file_path}"
      next
    end

    begin
      CSV.foreach(file_path, headers: true) do |row|
        node_params = row.to_h.symbolize_keys
        Node.create!(node_params)
      end
      puts "Import completed successfully."
    rescue => e
      puts "ERROR: Failed to import data - #{e.message}"
    end
  end
end
