---
title: 'PowerShell Module Base for Config Files'
date: 2022-03-21T09:14:41+01:00
draft: true

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

Sometimes you want to use a basic config file for your module. This config file should be used to define basic
settings without any user specific content. This file could be placed into your PowerShell Module folder.

Therefore you can use the automatic variable `$MyInvocation`, especially with its properties
`$MyInvocation.MyCommand.Module.ModuleBase`. This returns the full path to your current module base folder, which
can be used to join a path for your config file.

## 📑 `.\config.psd1` config file

Let's assume you start a new module and you need multiple config keys to work with. So you usually create a
json or powershell data based config file:

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

Now you can use `$MyInvocation.MyCommand.Module.ModuleBase` with a helper function to parse the path to your config
file and return your needed values:

```powershell
function Get-ConfigValue {
    <#
    .SYNOPSIS
        Returns the value of a given config file key.

    .PARAMETER ByKey
        Config file key.

    .OUTPUTS
        [string]

    .EXAMPLE
        Get-ConfigValue -ByKey 'OutputLevel'

    .NOTES
        Private module helper function. Used by other function within your module.
    #>

    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'Existing key from config file.')]
        [string]$ByKey
    )

    begin { }

    process {
        $ModuleBase = $MyInvocation.MyCommand.Module.ModuleBase
        $ConfigFile = Join-Path -Path $ModuleBase -ChildPath 'config.psd1'

        if (Test-Path -Path $ConfigFile) {
            try {
                $Config = Import-PowerShellDataFile -Path $ConfigFile
                Write-Output $Config.$ByKey
            }
            catch {
                Write-Error -Message $_.Exception.Message -ErrorAction Stop
            }
        }
        else {
            Write-Error -Message 'Config file not found!' -ErrorAction 'Stop'
        }
    }

    end { }
}
```

## 💭 Final Thoughts

All you need to to is using the `Get-ConfigValue -ByKey '<example key>'` in your functions to get the any value
defined in you config file.

As far as I know, that's the simplest way to get your module root and using it with a config file.

{{< alert >}}
Keep in mind not to store any sensitive data in you config file. User specific data should also be stored in a user
context and not in a global module wide config.
{{< /alert >}}
