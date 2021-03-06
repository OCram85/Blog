# Give Up GitHub

This project has given up GitHub.  ([See Software Freedom Conservancy's *Give Up  GitHub* site for details](https://GiveUpGitHub.org).)

You can now find this project at [https://gitea.ocram85.com/OCram85/Blog](https://gitea.ocram85.com/OCram85/Blog) instead.

Any use of this project's code by GitHub Copilot, past or present, is done without our permission.  We do not consent to GitHub's use of this project's code in Copilot.

Join us; you can [give up GitHub](https://GiveUpGitHub.org) too!

![Logo of the GiveUpGitHub campaign](https://sfconservancy.org/img/GiveUpGitHub.png)

<p align="right">
  <img src="http://forthebadge.com/images/badges/built-with-love.svg">
  <img src="http://forthebadge.com/images/badges/for-you.svg">
</p>

<p align="center">
  <a href="https://ocram85.com/">
    <img src="https://raw.githubusercontent.com/OCram85/Blog/master/assets/img/logo_square.png" alt="OCram85.com Logo" width="300" height="300">
  </a>
</p>

<h1 align="center">
  OCram85.com
</h1>

<p align="center">
  A personal blog about PowerShell, Automation and more.
</p>

<p align="center">
  <a href="https://github.com/OCram85/Blog">
    <img src="https://img.shields.io/github/license/OCram85/Blog" alt="Project License">
  </a>
  <a href="https://cloud.drone.io/OCram85/Blog">
    <img src="https://cloud.drone.io/api/badges/OCram85/Blog/status.svg" alt="Drone.IO Build">
  </a>
  <a href="https://hub.docker.com/r/ocram85/blog/tags">
    <img src="https://img.shields.io/docker/image-size/ocram85/blog/latest" alt="Docker Image Tags">
  </a>
</p>

## Tags

### `latest`

This tag contains currently active source for [OCram85.com](https://OCram85.com) and will be updated by changes on the master branch

### `next`

The next tag is used for testing any code changes on development branches and pull request. Site preview is available on [next.OCram85.com](https://next.OCram85.com)

## Content

This image contains the hugo based sources for my personal blog. It's made with the [Congo theme](https://github.com/jpanther/congo). The static pages are served by the included nginx server with a custom config. The custom config is needed to redirect 404 errors to a custom page.

You can simply run the container with `docker run -it --rm -p "8080:80" ocram85/blog:latest`
