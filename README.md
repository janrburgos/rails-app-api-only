# Base Rails App (API-only)

This is a minimal Ruby on Rails application designed for rapid prototyping and proof-of-concept development. It provides a lightweight foundation for testing new ideas, experimenting with gems, and building small-scale features before integrating them into larger projects.

## Makefile Commands

The following `make` commands help manage the application efficiently:

- **`make build`**: Builds the Docker image for the Rails application.
- **`make update`**: Runs `bundle install` inside the Docker container to install or update gems.
- **`make start`**: Starts the database and Rails application container.
- **`make stop`**: Stops the running Docker containers.
- **`make status`**: Displays the status of the Docker containers.
- **`make shell`**: Opens a bash shell inside the Rails application container for debugging and manual execution of commands.

## Purpose

- **Prototyping**: Quickly test new features and validate ideas before integrating them into a production environment.
- **Gem Testing**: Experiment with different gems in isolation without affecting larger applications.
- **Proof of Concept**: Develop and refine concepts with minimal overhead before scaling up.

This base Rails app provides a simple and flexible environment for quick iterations and efficient development.
