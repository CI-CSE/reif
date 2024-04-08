# Docs - Website files

This is the root folder of the documentation website.

The website is built using [Jekyll](https://jekyllrb.com/).

Jekyll is static site generator written in Ruby. It allows us to write Markdown files which will be converted to nice HTMLs.

## Local development
There is a Docker Compose file which includes the required dependencies.

First, Install Docker and Docker Compose. On Windows/Mac it is included in Docker Desktop.

To start development, run the compose file:
```bash
docker compose up
```
Docker compose will be running in the terminal window.

To log in to the compose shell run (in a diferent terminal window):
```bash
docker compose exec app bash
```

The further commands are to be executed from the inner shell.

Install Ruby dependencies:
```bash
bundle install
```

Run the Jekyll server:
```bash
bundle exec jekyll serve --host 0.0.0.0
```

Now you can visit https://localhost:4000 in your browser. You should see the website.
