# Status Name Classifier (Rumale)

This Ruby on Rails application uses the Rumale gem to classify status names into status types.

## Makefile Commands

The following `make` commands are available for managing the application:

- **`make build`**: Builds the Docker image for the Rails application.
- **`make update`**: Runs `bundle install` inside the Docker container.
- **`make start`**: Starts the database and Rails application container.
- **`make stop`**: Stops the running Docker containers.
- **`make status`**: Displays the status of the Docker containers.
- **`make shell`**: Opens a bash shell inside the Rails application container.

## Rake Commands

### Train Rumale Model

- **`bin/rails train_model:train`**: This task trains a machine learning model using the Rumale gem. The model is trained on a dataset of shipment status names and status types, applying text tokenization, word frequency encoding, and TF-IDF transformation before training a logistic regression classifier. The trained model, along with the TF-IDF transformer, label encoder, and vocabulary, is saved in the `ml_data/` directory.

## API Endpoint for Classification

### Endpoint: `POST /predict`

#### cURL Request

```sh
curl -X POST "http://localhost:3000/predict" \
     -H "Content-Type: application/json" \
     -d '{"status_name": "Shipment arrived at facility"}'
```

#### Response

```json
{
  "status_name": "Shipment arrived at facility",
  "status_type": "in_transit"
}
```

## Summary

This application utilizes Rumale to classify shipment status names into predefined status types. It includes:
- Docker-based setup and management via `Makefile`
- A Rake task for training the model
- An API endpoint for classification

To get started, run the necessary `make` and `rake` commands to build and train the model, then use the API to classify status names.

