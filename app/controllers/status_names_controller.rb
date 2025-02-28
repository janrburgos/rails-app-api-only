class StatusNamesController < ApplicationController
  def classify
    if params[:status_name].blank?
      render json: { error: "status_name cannot be empty" }, status: :bad_request
      return
    end

    classifier = StatusNameClassifier.new
    result = classifier.classify(params[:status_name])

    render json: {
      status_name: params[:status_name],
      status_type: result[:status_type],
      substatus_type: result[:substatus_type],
      confidence_score: result[:confidence_score]
    }
  end
end
