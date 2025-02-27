class PredictionsController < ApplicationController
  def predict
    classifier = StatusNameClassifier.new
    status_name = params[:status_name]
    status_type = classifier.predict(status_name)

    render json: { status_name: status_name, status_type: status_type }
  end
end