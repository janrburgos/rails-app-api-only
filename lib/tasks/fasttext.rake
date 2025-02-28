require 'csv'
require 'fasttext'
require 'fileutils'

namespace :fasttext do
  desc "Generate training data from CSV"
  task generate_training_data: :environment do
    input_csv = Rails.root.join('data/carrier_unique_shipment_statuses_data.csv')
    output_txt = Rails.root.join('data/carrier_unique_shipment_statuses_data.txt')

    unless File.exist?(input_csv)
      puts "Error: CSV file not found at #{input_csv}"
      exit 1
    end

    File.open(output_txt, 'w') do |file|
      CSV.foreach(input_csv, headers: true) do |row|
        status_name = row['status_name']&.strip.downcase.gsub(/[^a-z0-9\s]/i, '')
        status_type = row['status_type']&.strip
        substatus_type = row['substatus_type']&.strip

        next if status_name.nil? || status_type.nil?

        label = "__label__#{status_type.downcase.gsub(' ', '_')}"
        label += '-' # separator between combined labels
        label += "#{substatus_type.downcase.gsub(' ', '_')}" if substatus_type

        file.puts "#{label} #{status_name}"
      end
    end

    puts "Training data saved to: #{output_txt}"
  end

  desc "Train FastText model"
  task train: :environment do
    input_txt = Rails.root.join('data/carrier_unique_shipment_statuses_data.txt')
    output_model = Rails.root.join("ml_models/status_name_classifier.ftz")

    unless File.exist?(input_txt)
      puts "Error: Training data not found. Run `rake fasttext:generate_training_data` first."
      exit 1
    end

    # Ensure directory exists
    FileUtils.mkdir_p(File.dirname(output_model))

    model = FastText.train_supervised(
      input: input_txt.to_s,
      lr: 0.5,
      epoch: 30,
      word_ngrams: 3,
      minn: 3,
      maxn: 8,
    )
    model.quantize
    model.save_model(output_model.to_s)

    puts "Model trained and saved to: #{output_model}"
  end
end
