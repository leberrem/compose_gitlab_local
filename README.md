## prereqs

Install docker, make on LINUX

add `172.0.0.1 gitlab.localhost.com` in your file `/etc/hosts`

## Login credentials

The default user is `root` and password is `password`

## Initialize and start gitlab stack

make init

## Register gitlab runner

make register

## Stop gitlab stack

make stop

## Start gitlab stack

make start

## Remove gitlab stack

make remove

## Sample for test gitlab CI

.gitlab-ci.yml

```yaml
stages:
 - build

test:
  stage : build
  tags:
   - docker
  script:
   - echo "Well Done!!!"
```

## Sample for test gitlab CI + build docker

Dockerfile

```Dockerfile
FROM alpine:latest
CMD ["echo", "Well Done!!!"]
```

.gitlab-ci.yml

```yaml
image: docker:stable

before_script:
  - docker info

build:
  stage: build
  tags:
   - docker    
  script:
    - docker build -t my-docker-image .
    - docker run --rm my-docker-image
```

## Sample for test gitlab CI + build docker + push image

Dockerfile

```Dockerfile
FROM alpine:latest
CMD ["echo", "Well Done!!!"]
```

.gitlab-ci.yml

```yaml
image: docker:stable

variables:
  IMAGE_TAG: $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG

before_script:
  - docker info
  - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY  

build:
  stage: build
  tags:
   - docker    
  script:
    - docker build -t $IMAGE_TAG .
    - docker run --rm $IMAGE_TAG
    - docker push $IMAGE_TAG
```