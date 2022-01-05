![logo](https://raw.githubusercontent.com/OCram85/Blog/master/assets/img/logo_square.png)

> A personal blog about PowerShell, Automation and more.

## Tags

- `latest`
  - This tag contains currently active source for [OCram85.com](https://OCram85.com) and will be updated by changes on the master branch
- `next`
  - The next tag is used for testing any code changes on development branches and pull request. Site preview is available on [next.OCram85.com](https://next.OCram85.com)

## Content

This image contains the hugo based sources for my personal blog. It's made with the [Congo theme](https://github.com/jpanther/congo). The static pages are served by the included caddy server with a custom config. The custom config is needed to redirect 404 errors to a custom page.

You can simply run the container with `docker run -it --rm -p "8080:8080" ocram85/blog:latest`
