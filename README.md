# Sylius Docker Environment

This project is intended as boilerplate and for bootstrapping your 100% dockerized Sylius development environment. It can also be used as blueprint to use in an automated deployment pipeline achieving Dev/Prod-Parity.

The development environment consists of 3 containers, running

  * nginx and php-fpm (7.1) using [sylius/docker-nginx-php-fpm](https://hub.docker.com/r/sylius/nginx-php-fpm/) as base image
  * Percona 5.7 as database
  * [MailHog](https://github.com/mailhog/MailHog) for testing outgoing email

You can control, customize and extend the behaviour of this environment with ``make`` - see ``make help`` for details. It is built around the principles and ideas of the [Docker Make Stub](https://github.com/25th-floor/docker-make-stub).

## Development

### Quickstart

```
git clone https://github.com/sylius/docker sylius-docker
make help
make up
make shell

root@aa67dd3b767c:/var/www# cd sylius/
root@aa67dd3b767c:/var/www/sylius# bin/console sylius:install
```

### Accessing services and ports

| Service        | Port  | Internal DNS | Exported |
|----------------|-------|--------------|----------|
| Sylius (HTTP)  | 8000  | sylius       | Yes      |
| MySQL          | 3606  | mysql        | Yes      |
| MailHog (SMTP) | 1025  | mailhog      | No       |
| MailHog (HTTP) | 8025  | mailhog      | Yes      |

### Customizing docker-compose.yml

You can create a ``docker-compose.local.yml`` to further extend the docker-compose configuration by overloading the existing YAML configuration. If this file exists ``make up`` will recognize and add it as ``-f docker-compose.local.yml`` when executing docker-compose.

For example:

```yaml
version: '2'

services:
  sylius:
    environments:
      - ADDITIONAL_ENV=yesplease
```

Please note array elements (ports, environments, volumes, ...) will get **merged** and **not replaced**. If you want to see this happen have a look at [https://github.com/docker/compose/pull/3939](https://github.com/docker/compose/pull/3939) and vote for this PR.

To change the e.g. exposed ports for your local environment you have to edit ``docker-compose.yml`` for now.

## Support for you Deployment Pipeline

TODO

# Todo

  * Integrate an Asset Builder
  * Run ``sylius:install`` when required
  * Run ``composer create-project`` when required (required for volume mount)
  * Predefine project and network name (currently docker-compose generates one based on the root directory name)