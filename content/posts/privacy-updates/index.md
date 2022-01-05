---
title: 'Privacy Updates'
date: 2022-01-05T11:17:19+01:00
draft: false
tags: ['privacy']
# lastmod: 2022-01-05T11:17:19+01:00
# showDateUpdated: true

# custom overrides for pages
# showDate: false
# showAuthor: false
# showWordCount: false
# showReadingTime: false
# showEdit: false
# sharingLinks: [null]
---

## General

This blog is based on jpanther`s hugo theme [congo](https://github.com/jpanther/congo). Due to the requirements
of the GDPR, I reworked some parts to ensure to be compliant. Because I'm not a native English speaker or lawyer,
I'm not able to provide you a fully detailed privacy policy in English, which would justice you or the German
legislation.

But to be as transparent as possible I'll try my best to explain and what kind of data will be collected.

## Shared Data Overview

### Public IP

{{< note >}}
Please don't ask why we are sharing your IP with these
providers: Technically you need an address to transfer any data through the internet !
{{< /note >}}

The following table shows who could get access to your public IP while browsing on this blog.

| Data | Accessible By | Collected By |    Used For    | Retention Time |
| :--: | :-----------: | :----------: | :------------: | :------------: |
|  IP  |      Me       |  Webserver   |    Security    |     7 days     |
|  IP  |      Me       |    Umami     | Web Statistics |     7 days     |

Removed data providers / features:

- Disqus
- cloudflare

### Cookies

While moving the the current theme, I could remove all previously used cookies:

- Disqus
- cloudflare
- Cookie-Consent

## Design Changes

- I've added a detailed page called [Datenschutz](/datenschutz) which contains all needed sections requested by the
  GDPR.

## Hosting Changes

Another big step was moving away from the github provided hosting service called github-pages and its CI/CD tools.
I'm absolutely happy with this service, but I was forced to host this blog by myself to ensure I
know what happens with your data. This enables me to tell you which data will be collected by the webserver while
you browse on this page.

To secure my systems I need to collect your IP and store them into the webserver's access and error logs.
The logs will be deleted after 7 days.

## Used Tools Overview

### Web Statistics (Umami)

This site uses a self hosted instance of Umami to monitor the visits and traffic on this blog.
Umami collects data without using a cookie. Your data is used to generate anonymized statistics. Detailed
information about this can be found on the [Umami page](https://umami.is/docs/faq) itself.

You can also visit the the [umami web statistics](https://umami.ocram85.com/share/KAk7LmbU/Blog) page to
see all the collected data.
