
## Login credentials

* Gitlab default user is `root` and password is `password`
* Minio default user is `minio` and password is `minio123`

## Tips

For using locally `gitlab API`, `gitlab Web IDE` and `gitlab container registry`, you must have a local IP for `gitlab` host
Please add `127.0.0.1 gitlab` to `/etc/hosts`

* GITLAB : http://gitlab:8929
* GITLAB API : http://gitlab:8929/api/v4/version

---

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

---

## Gitlab CI pipeline - simple

<details><summary>Code</summary>
<p>

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
</p>
</details>

## Gitlab CI pipeline - build docker

<details><summary>Code</summary>
<p>

Dockerfile

```Dockerfile
FROM alpine:latest
CMD ["echo", "Well Done!!!"]
```

.gitlab-ci.yml

```yaml
stages:
- build

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

</p>
</details>

## Gitlab CI pipeline - build docker + push image

<details><summary>Code</summary>
<p>

Dockerfile

```Dockerfile
FROM alpine:latest
CMD ["echo", "Well Done!!!"]
```

.gitlab-ci.yml

```yaml
stages:
- build

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

</p>
</details>

## Gitlab CI pipeline - artefact

<details><summary>Code</summary>
<p>

.gitlab-ci.yml

```yaml
stages:
- build
- test

build-job:
  stage : build
  image: alpine:latest
  tags:
  - docker
  script:
  - echo "Well Done!!!" > test_artefact.txt
  artifacts:
      paths:
      - test_artefact.txt
      expire_in: 1 min

test-job:
  stage: test
  image: alpine:latest
  tags:
  - docker
  script:
  - cat test_artefact.txt
  dependencies:
  - build-job

```

</p>
</details>

## Gitlab CI pipeline - cache

<details><summary>Code</summary>
<p>

package.json
```json
{
  "dependencies": {
    "express": "latest"
  }
}
```

app.js
```javascript
const express = require('express')
const app = express()

app.get('/', function (req, res) {
  res.send('Well Done!!!')
})

app.listen(3000, function () {
  console.log('App listening on port 3000!')
})
```

.gitlab-ci.yml

```yaml
stages:
- test

cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
  - node_modules/

before_script:
- npm install

test-job:
  stage: test
  image: node:latest
  tags:
  - docker
  script:
  - node app.js &
  - sleep 3
  - curl -s 'http://localhost:3000'
```

</p>
</details>

## Gitlab CI pipeline - service

<details><summary>Code</summary>
<p>

<u>Caveat :</u><br>
Actually there is an error while launching service.<br>
A bug exist when a runner launched with `docker-network-mode` option

.gitlab-ci.yml

```yaml
services:
- name: mongo:latest
  alias: db-mongo

stages:
- build
- test

create-job:
  stage: build
  services:
  - name: mongo:latest
    alias: db-mongo  
  image: 
    name: mongo:latest
    entrypoint: [""]
  tags:
  - docker
  script:
  - mongo --host db-mongo --eval "db.createCollection('Well_Done');"

test-job:
  stage: test
  image: 
    name: mongo:latest
    entrypoint: [""]
  tags:
  - docker
  script:
  - mongo --host db-mongo --eval "db.getCollectionNames();"
```

</p>
</details>
