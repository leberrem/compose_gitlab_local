init:
	docker-compose up -d

log:
	docker-compose logs -f

stop:
	docker-compose stop

start:
	docker-compose start

register:
	docker-compose exec gitlab-runner \
	  gitlab-runner register \
	    --non-interactive \
		--url http://gitlab.localhost.com:8929/ \
		--registration-token token \
		--tag-list docker \
		--executor docker \
		--description "My Docker Runner" \
		--docker-image alpine:latest \
		--docker-network-mode compose-gitlab_default \
		--docker-volumes '/var/run/docker.sock:/var/run/docker.sock' \
		--docker-volumes '/cache'

remove:
	sudo rm -rf ../gitlab/config/* ../gitlab/data/* ../gitlab/logs/* ../gitlab-runner/config/* ../minio/data/*
	docker-compose rm -f -s