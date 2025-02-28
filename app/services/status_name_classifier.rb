require 'fasttext'

class StatusNameClassifier
  MODEL_PATH = Rails.root.join("ml_models/status_name_classifier.ftz")
  STATUS_TYPES = {
    'info' => 'Info',
    'transit' => 'Transit',
    'exception' => 'Exception'
  }
  SUBSTATUS_TYPES = {
    'incorrect_info' => 'Incorrect Info',
    'loss/returns' => 'Loss/Returns',
    'pick_up_confirmed' => 'Pick Up Confirmed',
    'other_delays' => 'Other Delays',
    'delivered' => 'Delivered',
    'customs/tax_delays' => 'Customs/Tax Delays',
    'carrier_delays' => 'Carrier Delays',
    'onboard_at_departure_terminal' => 'Onboard at Departure Terminal',
    'natural_causes' => 'Natural Causes',
    'traffic_delays' => 'Traffic Delays',
    'document_handover' => 'Document Handover',
    'cancelled' => 'Cancelled',
    'delayed' => 'Delayed'
  }

  def initialize
    @model = FastText.load_model(MODEL_PATH.to_s)
  end

  def classify(status_name)
    prediction = @model.predict(status_name, k: 1)
    if prediction.present?
      status_type, substatus_type = prediction.keys.first.split('-')
      confidence_score = prediction.values.first
    end

    {
      status_type: status_type.presence || STATUS_TYPES['transit'],
      substatus_type: substatus_type.presence,
      confidence_score: confidence_score
    }
  end
end
