# pipeline-apps

## Building and releasing the docker image

Ensure you are logged in locally to hub.docker.com using `docker login` (note: your username is used, not your email address).

```
$ docker build ./ --tag way2web/pipeline-apps:TAG
$ docker push way2web/pipeline-apps:TAG
```
Replace `TAG` with either develop or latest. 

Please note, that latest is used in production. 
So only tag and push this one once you know there are no issues with the current build!

## Testing the image locally

```
$ docker-compose up --build
$ docker exec -it pipeline-apps bash
```

## Accessing projects
Projects are mounted to `/var/www/projects`.

## Running MySQL
`/usr/bin/mysqld_safe --user=mysql &`

## Interacting with MySQL
`mysql -u root -proot`
