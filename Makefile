.PHONY: buildLocalBase
buildLocalBase:
	docker build --rm -t rails-local-app -f Dockerfile-local .
	docker image prune -f

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

.PHONY: appShell
appShell:
	docker exec -it rails-app bash
