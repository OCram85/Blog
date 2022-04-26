---
title: 'How to get your PowerShell Module Base root path'
date: 2022-03-21T09:14:41+01:00
#draft: true

categories: ['PowerShell']
tags: ['ModuleBase', 'config']
# lastmod: 2022-03-21T09:14:41+01:00
# showDateUpdated: true

# custom overrides for pages
# showDate: false
# showAuthor: false
# showWordCount: false
# showReadingTime: false
# showTableOfContents: false
# showTaxonomies: false
# showEdit: false
# sharingLinks: [null]
---

![note](note.jpg 'Photo by [Sigmund](https://unsplash.com/@sigmund) on [Unsplash](https://unsplash.com)')

## 🖼️ Intro

This article explains with a practical example how to determine and use the current module base path.

Sometimes you want to use a basic config file for your module. This config file could be used to define basic
settings for your module. These module wide default settings should placed and shipped within your module.

Therefore you can use the automatic variable `$MyInvocation`, especially with its properties
`$MyInvocation.MyCommand.Module.ModuleBase`. This returns the full path to your current module base folder, which
can be used by your function to join a path for your config file.

## 📑 `.\config.psd1` config file

Let's assume you start a new module and you need multiple config keys to work with. So you usually create a
**JSON** or **P**ower**S**hell **D**ata format based config file:

```powershell
{
    # Logging
    OutputLevel         = 'Detailed'
    DefaultTarget       = 'Console'
    LogRetentionInWeeks = 4

    # DataSource
    CouchDBURI = 'http://localhost'
    MongoDBURI = 'http://mongodb'

    # ...
    # ...
}
```

## 🔎 `Get-ConfigValue` helper function

Now you can use `$MyInvocation.MyCommand.Module.ModuleBase` with a helper function, to parse the path to your config
file, and return the stored default values:

```powershell
function Get-ConfigValue {
    <#
    .SYNOPSIS
        Returns the value of a given config file key.

    .PARAMETER FromKey
        Config file key.

    .OUTPUTS
        [string]

    .EXAMPLE
        Get-ConfigValue -FromKey 'OutputLevel'

    .NOTES
        Private module helper function. Used by other function within your module.
    #>

    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'Existing key from config file.')]
        [string]$FromKey
    )

    begin { }

    process {
        $ErrorActionPreference = 'Stop'
        $ModuleBase = $MyInvocation.MyCommand.Module.ModuleBase
        $ConfigFile = Join-Path -Path $ModuleBase -ChildPath 'config.psd1'

        if (Test-Path -Path $ConfigFile) {
            try {
                $Config = Import-PowerShellDataFile -Path $ConfigFile
                Write-Output $Config.$FromKey
            }
            catch {
                Write-Error -Message $_.Exception.Message
            }
        }
        else {
            Write-Error -Message 'Config file not found!'
        }
    }

    end { }
}
```

## 💭 Final Thoughts

All you need to to is using the `Get-ConfigValue -FromKey '<example key>'` in your functions to get any value
defined in your config file.

As far as I know, that's the simplest way to get your module root and using it with a config file.

{{< alert >}}
Do not to store any sensitive data in you config file. User specific data should also be stored in a user
context and not in a global module wide config file.
{{< /alert >}}
