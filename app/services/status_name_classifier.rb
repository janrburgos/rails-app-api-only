require 'rumale'
require 'numo/narray'

class StatusNameClassifier
  MODEL_PATH = 'ml_data/model.dump'
  TFIDF_PATH = 'ml_data/tfidf.dump'
  LABEL_ENCODER_PATH = 'ml_data/label_encoder.dump'
  VOCABULARY_PATH = 'ml_data/vocabulary.dump'

  def initialize
    # Load trained model components
    @model = load_model(MODEL_PATH)
    @tfidf = load_model(TFIDF_PATH)
    @label_encoder = load_model(LABEL_ENCODER_PATH)
    @vocabulary = load_model(VOCABULARY_PATH)

    raise 'Model not loaded properly!' unless @model && @tfidf && @label_encoder && @vocabulary
  end

  def predict(status_name)
    return 'Invalid input' if status_name.nil? || status_name.strip.empty?

    # Preprocess text: tokenize & convert to word frequency
    words = status_name.downcase.split(/\W+/)
    x_counts = Numo::DFloat.zeros(1, @vocabulary.size)
    words.each { |word| x_counts[0, @vocabulary[word]] += 1 if @vocabulary[word] }

    # Apply TF-IDF transformation
    x_tfidf = @tfidf.transform(x_counts)

    # Predict
    prediction = @model.predict(x_tfidf)[0]
    @label_encoder.inverse_transform([prediction])[0]
  end

  private

  def load_model(path)
    File.exist?(path) ? Marshal.load(File.read(path)) : nil
  end
end
