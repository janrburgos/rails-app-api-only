# Status Name Classifier (FastText)

This Ruby on Rails application uses the FastText gem to classify status names into status type and substatus type.

## Makefile Commands

The following `make` commands are available for managing the application:

- **`make build`**: Builds the Docker image for the Rails application.
- **`make update`**: Runs `bundle install` inside the Docker container.
- **`make start`**: Starts the database and Rails application container.
- **`make stop`**: Stops the running Docker containers.
- **`make status`**: Displays the status of the Docker containers.
- **`make shell`**: Opens a bash shell inside the Rails application container.

## Rake Commands

### Generate Training Data from CSV

- **`bin/rails fasttext:generate_training_data`**: This task reads a CSV file containing shipment status names and formats it into a text file suitable for FastText training.

### Train FastText Model

- **`bin/rails fasttext:train`**: This task trains a FastText model using the generated training data and saves the trained model for later classification.

## API Endpoint for Classification

### Endpoint: `POST /classify`

#### cURL Request

```sh
curl -X POST "http://localhost:3000/classify" \
     -H "Content-Type: application/json" \
     -d '{"status_name": "Shipment arrived at facility"}'
```

#### Response

```json
{
  "status_name": "Shipment arrived at facility",
  "status_type": "in_transit",
  "substatus_type": "arrived",
  "confidence_score": 0.85
}
```

## Summary

This application utilizes FastText to classify shipment status names into predefined status types and substatus types. It includes:
- Docker-based setup and management via `Makefile`
- Rake tasks for generating training data and training the model
- An API endpoint for classification

To get started, run the necessary `make` and `rake` commands to build and train the model, then use the API to classify status names.

