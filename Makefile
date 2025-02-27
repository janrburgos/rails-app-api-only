.PHONY: build
build:
	docker build --rm -t rails-local-app -f Dockerfile-local .
	docker image prune -f

.PHONY: update
update:
	docker-compose run --rm rails-app bundle install

.PHONY: start
start:
	docker-compose up --detach db
	until docker-compose run --rm rails-app bin/rails db:prepare; do echo "Waiting for database..."; sleep 2; done
	docker-compose run --name rails-app --rm --service-ports rails-app

.PHONY: stop
stop:
	docker-compose stop

.PHONY: status
status:
	docker-compose ps

.PHONY: shell
shell:
	docker exec -it rails-app bash
