# Jetty WordPress Image
> This image is based off the official Docker image maintained by the Docker community: https://hub.docker.com/_/wordpress

## Adding New Image Versions
The `versions.yml` contains the config for the image versions supported. When adding new versions, please check the tags supported by the WordPress image: https://hub.docker.com/_/wordpress/tags.

Example `versions.yml`:
```yml
6.0: [8.1, 8,0]
```

This will generate the `config.json` for the CircleCI `bigbite/docker-image-extend` orb, containing WordPress 6.0, with PHP versions 8.1 and 8.0:

Example generated `conifg.json`:
```json
[
    { "tag": "6.0-php8.1", "args": { "WORDPRESS_IMAGE": "6.0-php8.1" } },
    { "tag": "6.0-php8.0", "args": { "WORDPRESS_IMAGE": "6.0-php8.0" } },
]
```

To generate the `config.json` file, run:

```
./generate-config.sh versions.yml > config.json
```
