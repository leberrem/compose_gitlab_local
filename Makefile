init:
	mkdir -p data/gitlab/config
	mkdir -p data/gitlab/data
	mkdir -p data/gitlab/logs
	mkdir -p data/gitlab-runner/config
	mkdir -p data/minio/data
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
		--url=http://gitlab:8929/ \
		--clone-url=http://gitlab:8929 \
		--registration-token=token \
		--tag-list=docker \
		--executor=docker \
		--description="My Docker Runner" \
		--docker-image=alpine:latest \
		--docker-network-mode=gitlab-network \
		--docker-volumes='/var/run/docker.sock:/var/run/docker.sock' \
		--cache-type=s3 \
		--cache-path=gitlab-runner \
		--cache-shared=true \
		--cache-s3-server-address=minio:9000 \
		--cache-s3-access-key=minio \
		--cache-s3-secret-key=minio123 \
		--cache-s3-bucket-name=gitlab \
		--cache-s3-insecure=true

remove:
	docker-compose rm -f -s
	@for container in $$(docker ps -q -a --filter exited=0 --filter name=runner-.*-project-.*-concurrent-.*-cache-.*$$); do docker rm $$container; done;
	sudo rm -rf ./data/*
