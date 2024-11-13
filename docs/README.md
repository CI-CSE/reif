# Docs - Website files

This is the root folder of the documentation website.

The website is built using [Jekyll](https://jekyllrb.com/) and [Tailwind CSS](https://tailwindcss.com/).

Jekyll is a static site generator written in Ruby. It allows us to write Markdown files which will be converted to nice HTMLs.

Tailwind is a CSS framework which allows us to build the design directly in the HTML files using special CSS classes.

## Deployment
The website is built and deployed automatically on every push to the main branch (`research`).

Check the workflow file for the implementation details `.github/workflows/docs.yml`.

### Site code in `reif`, site deployed to `reif-site`
Site is built in this repository and deployed to a different repository https://github.com/CI-CSE/reif-site
because having a private repo with public pages is a paid feature on GitHub.
`reif` repo is private and `reif-site` is public and contains only the website.

`reif` repo has a GitHub repository secret `REIF_SITE_DEPLOY_KEY` which contains
a private ssh key. This key is used in the deploy action.
`reif-site` repo has a GitHub deploy key `CI-CSE/reif deploy action` which
allows `REIF_SITE_DEPLOY_KEY` to be used to write to `reif-site` repo.

## Development

### Running locally
There is a Docker Compose file which includes the required dependencies.

First, Install Docker and Docker Compose. On Windows/Mac it is included in Docker Desktop.

First, execute the following command in the terminal to start docker compose:
```bash
docker compose up
```
Docker compose will be running in the terminal window.

Run the following command in a different terminal to log into the compose shell:
```bash
docker compose exec app bash
```

All commands from now on are to be executed from the inner shell.

Install Ruby dependencies:
```bash
bundle install
```

Install JS dependencies:
```bash
yarn install
```

Run the Jekyll server:
```bash
bundle exec jekyll serve --host 0.0.0.0 --livereload
```

Now you can visit http://localhost:4000/trunk/ (not `http`**s**) in your browser. You should see the website.

It is possible to configure SSL with Jekyll for localhost.
Check `jekyll serve --help` for `--ssl-{key,cert}` options and check
<https://claytonerrington.com/blog/securing-jekyll-with-ssl-locally/>.

> [!NOTE]
> Note the `/trunk/` in the end of the local path. It mimics the path on GitHub pages.

The website will reload automatically when files are changed, thanks to the `--livereload` parameter.


### Tailwind
Tailwind is a popular framework so it should be easy to find info online. However,
here are some important notes which might be easy to miss:

Tailwind removes unused classes from the production CSS bundle. Only the files listed in `tailwind.config.js`
are checked. So, if some styles are missing from the production build,
check that the required patterns are in `tailwind.config.js`.
