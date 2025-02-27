namespace :train_model do
  desc "Train the Rumale model for shipment status classification"
  task train: :environment do
    require 'rumale'
    require 'numo/narray'
    require 'csv'
    require 'fileutils' # ✅ Ensure directory creation

    # Ensure 'ml_data' directory exists
    FileUtils.mkdir_p('ml_data')

    # Load dataset
    data = CSV.read('data/carrier_unique_shipment_statuses_data.csv', headers: true)

    # Extract features (status name) and labels (status type)
    x_text = data.map { |row| row['status_name'] }
    y_labels = data.map { |row| row['status_type'] }

    # Encode labels to numerical categories
    label_encoder = Rumale::Preprocessing::LabelEncoder.new
    y = label_encoder.fit_transform(y_labels)

    # **Manual Tokenization + Word Frequency Encoding**
    vocabulary = {}
    tokenized_texts = x_text.map do |text|
      words = text.upcase.split(/\W+/) # Tokenize words
      words.each { |word| vocabulary[word] ||= vocabulary.size }
      words
    end

    # Convert tokenized text into count matrix
    x_counts = Numo::DFloat.zeros(x_text.size, vocabulary.size)
    tokenized_texts.each_with_index do |words, i|
      words.each do |word|
        x_counts[i, vocabulary[word]] += 1 if vocabulary[word]
      end
    end

    # Apply TF-IDF transformation
    tfidf = Rumale::FeatureExtraction::TfidfTransformer.new
    x_tfidf = tfidf.fit_transform(x_counts)

    # Train a Logistic Regression model
    model = Rumale::LinearModel::LogisticRegression.new
    model.fit(x_tfidf, y)

    # ✅ Ensure directory exists & Save trained model
    File.open('ml_data/model.dump', 'wb') { |f| f.write(Marshal.dump(model)) }
    File.open('ml_data/tfidf.dump', 'wb') { |f| f.write(Marshal.dump(tfidf)) }
    File.open('ml_data/label_encoder.dump', 'wb') { |f| f.write(Marshal.dump(label_encoder)) }
    File.open('ml_data/vocabulary.dump', 'wb') { |f| f.write(Marshal.dump(vocabulary)) }

    puts "✅ Model trained and saved in ml_data/!"
  end
end
