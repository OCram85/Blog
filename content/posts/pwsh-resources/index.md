---
title: 'A Journey to the PowerShell Citadel ✨🧙'
date: 2017-12-14T14:37:54+01:00
showDateUpdated: true
lastmod: 2022-01-11T08:37:54+01:00
draft: false
categories: ['PowerShell']
tags: ['resources']
draft: false
---

{{< figure src="res-posh.jpg" width="1200" height="800" caption="Photo by Eugenio Mazzone on Unsplash." >}}

## The Journey Begins Now Young Novice

In this section you find the most basic stuff. It's aimed to help beginners who just got in touch with PowerShell.
All external links refer to the latest production ready PowerShell version.
This is currently the version `7.2.1 LTS`. If you're force to use PSSnapins you still have to use the version `5.1`.

### Docs

- [Official Documentation] - Microsoft recently moved all the PowerShell documentation to [docs.microsoft.com].
- [PowerShell Reference] - If you need details about a specific function or cmdlets you can find it there. The
  Reference is grouped by the built in modules. You can expand each group and select the individual help page of
  each function.
- [About Pages] - The docs does not only contain a reference of all the built in functions. It also contains the so
  called _About_ pages. These pages explain specific concepts and language related topics. You can find them in a
  separate _about_ section of the **Microsoft.PowerShell.Core** module reference. The titles always starts with
  \_about\_\_ and the specific name.
- [The Monad Manifesto] - The Monad Manifesto is the original Jeffrey Snover-authored document that results in the
  Windows PowerShell we know today.

[official documentation]: https://docs.microsoft.com/en-us/powershell
[docs.microsoft.com]: https://docs.microsoft.com
[powershell reference]: https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.2
[about pages]: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about?view=powershell-7.2
[the monad manifesto]: https://devops-collective-inc.gitbook.io/the-monad-manifesto-annotated/

{{< note >}}
You can also display the \_about\_ pages with a PowerShell function itself. To get a list of all about
pages just use `Get-Help about_\*`. All you need to to is pick a topic name and use the function again like this:
`Get-Help about_Functions`.
{{< /note >}}

### Start using PowerShell

You can't learn PowerShell like every other language if you don't use it. So try to solve basic tasks with PowerShell.
Google around or ask questions in communities like:

- [StackOverflow] - The bes QA platform out there for finding solutions and help for specific topics or questions.
  Don't post general or vague questions.
- [PowerShell.org] - A very helpful and friendly community.

[stackoverflow]: https://stackoverflow.com/questions/tagged/powershell
[powershell.org]: https://forums.powershell.org/

## Acolyte

Once you got familiar with the basic concepts start discovering advanced techniques like _Functions_,
_Modules_, _Classes_, _Types_, _Extended Type System_, _PowerShell Remoting_, _Jobs_, _Package Management_.

### It's all about the style

As soon as you managed to spell `PowerShell` please respect the [PowerShell Best Practices and Style Guide](https://github.com/PoshCode/PowerShellPracticeAndStyle).
Unfortunately there is no standard like _PEP8_ in Python, but this is the most respected and active one. Trust me -
it's maintained by all the experts out there. Just read it, understand it, adopt it and use whatever you can.

{{< alert >}}
**IMPORTANT:** There is nothing worse than reading an ugly piece of code. And yes, ugly code works as well but it's
impossible to read, understand, review, maintain and makes no fun!
{{< /alert >}}

### Important Modules

- [PSScriptAnalyzer] - Static code checker for PowerShell modules and scripts.
- [Pester] - Test and mock framework
- [platyPS] - Write PowerShell External Help in Markdown.
- [Plaster] - Plaster is a template-based file and project generator written in PowerShell.
- [psake] - A build automation tool.

[psscriptanalyzer]: https://github.com/PowerShell/PSScriptAnalyzer
[pester]: https://github.com/pester/Pester
[platyps]: https://github.com/PowerShell/platyPS
[plaster]: https://github.com/PowerShell/Plaster
[psake]: https://github.com/psake/psake

### Tools

In this phase you should also start working with additional tools like:

- VCS (Version Control System):
  - [Git-SCM](https://git-scm.com/)
- additional Editors, IDEs:
  - [Visual Studio Code](https://code.visualstudio.com/)
- CI/CD Environments:
  - [Github](https://github.com/)
  - [Gitea](https://gitea.io/)
  - [Drone](https://www.drone.io/)
  - [AppVeyor](https://www.appveyor.com/)
  - [GoCD](https://www.gocd.org/)
- Helper
  - [ILSpy](http://ilspy.net/)
- Coverage Reports
  - [Coveralls.io](https://coveralls.io/)
  - [Codecov](https://codecov.com)

{{< note >}}
If you develop open source projects I recommend using [Github](https://github.com/) in combination with its
[Actions](https://github.com/features/actions) feature or [Drone](https://www.drone.io/).
You don't need to maintain any additional infrastructure and they are free for public repositories.
Otherwise I like working with Gitea as _Git Server_ and project coordination. If you take this path you definitely
need a build server Drone. I definitely recommend running these as container in a Docker or even Kubernetes
environment.
{{< /note >}}

## Maester

Now you mastered the core concepts, know advanced stuff like _PowerShell Remoting_, _Desired Sate Configuration_
and important additional modules. Now it's important to keep up to date and network. Get input from others and
spread the work of PowerShell while teaching others!

### Grand Maester Blogs

- [dille.name] - An awesome DevOps Engineer and Docker Captain with outstanding
  Microsoft and PowerShell knowledge.
- [DonJones.com] - If you never heard about DonJones I can't help you. He is one of the biggest
  maesters in the PowerShell citadel and a great inspiration.
- [PowerShellExplained] - A great blog about various PowerShell topics by Kevin Marquette.
- [keithhill.wordpress.com] - One of the 4 maintainers of the [PowerShell Extension]
  for [VS Code].
- [xainey.github.io] - Michael Willis blog contains great articles about PowerShell classes,
  module creation and building frontend for PowerShell. It's high quality content and easy to follow expert topics.

[dille.name]: http://dille.name
[donjones.com]: https://donjones.com/powershell/
[powershellexplained]: https://powershellexplained.com/
[keithhill.wordpress.com]: http://rkeithhill.wordpress.com
[xainey.github.io]: https://xainey.github.io/
[powershell extension]: https://github.com/PowerShell/vscode-powershell
[vs code]: https://code.visualstudio.com/

### Get in touch with the Archmaesters

Take a look at the [PowerShell Slack Team](http://powershell.slack.com/) if your searching other active PowerShell experts.

## Additional Resources

- [Writing Modules]- Resources for writing PowerShell Modules. from
  _Writing PowerShell Modules: Tips, Tools, and Best Practices session at the 2017 PowerShell + DevOps Global Summit_
- [Awesome PowerShell] - A curated list of delightful PowerShell packages and resources.

[writing modules]: https://github.com/RamblingCookieMonster/WritingModules
[awesome powershell]: https://github.com/janikvonrotz/awesome-powershell
