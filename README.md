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

## Laravel Dusk Chrome Driver

If the image is updated, Chrome is updated as well. This might break your Dusk test if you are using an older Chrome driver.
To make sure this does not happen, you can use artisan to download the proper Chrome driver based on this image's Chrome version.

A `CHROME_VERSION` environment variable is available containing the current Chrome version (i.e. `79`). So you can automate downloading the proper Chrome version like this:

```bash
php artisan dusk:chrome-driver ${CHROME_VERSION}
```

If the platform you run Dusk on does not support reading the environment variables from the docker image, you can, for example, manually create the variable, like so:

```bash
CHROME_VERSION=$(cat /root/chrome_version)
```

Make sure you create it before running the download command.

## Accessing projects
Projects are mounted to `/var/www/projects`.

## Running MySQL
`/usr/bin/mysqld_safe --user=mysql &`

## Interacting with MySQL
`mysql -u root -proot`
