# pipeline-apps

## Available tags
- `latest`

## Building and publishing

Ensure you are logged in locally to hub.docker.com using `docker login` and have access to the hub repository.
(note: your username is used, not your email address).

```
$ docker build ./ --tag way2web/pipeline-apps:TAG
$ docker push way2web/pipeline-apps:TAG
```

Replace `TAG` with the tag you are working on.

## Development

If you want to test a new feature, create a new tag for it. This way, it can not introduce issues in the production image if something is not working properly.

Once it works, delete the custom tag and introduce it into `latest`

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
