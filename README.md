# DOCKER SYMFONY SEED WINDOWS PROJECT

## Getting Started

1. [Install Docker Compose](https://docs.docker.com/compose/install/) (v2.10+)
2. [Install make](https://community.chocolatey.org/packages/make)
3. Run `make start` to build fresh images
4. Open `http://localhost` in your favorite web browser
5. Run `make down` to stop the Docker containers.

## Makefile
You can see all the commands in the [Makefile](Makefile).

## Tools
You can use these tools on this project.

- [PHP-CS-FIXER](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer)
```bash
make phpcs
```

- [PHPSTAN](https://phpstan.org/)
```bash
make phpstan
```

- [RECTOR](https://github.com/rectorphp/rector)
```bash
make rector
```

- [PHPUnit](https://phpunit.de/)
```bash
make phpunit
```

## Features

* Dev ready, one command and go
* Super-readable configuration

## Coming SOON
* Automatic HTTPS (in dev and prod)
* XDebug integration for Dev env

## License
The Docker part is available under the MIT License.

## Credits
Created by [Anthony Legrand](https://www.linkedin.com/in/legranthony/)