---
title: 'Parameter Validation with PSTypeName'
date: 2022-03-16T09:24:56+01:00
#draft: true

categories: ['PowerShell']
tags: ['parameter', 'validation', 'PSTypeName']
lastmod: 2022-03-22T09:00:00+01:00
showDateUpdated: true
# custom overrides for pages
# showDate: false
# showAuthor: false
# showWordCount: false
# showReadingTime: false
# showTableOfContents: false
# showTaxonomies: true
# showEdit: false
# sharingLinks: [null]
---

![ship](ship.jpg 'Photo by [Rod Long](https://unsplash.com/@rodlong) on [Unsplash](https://unsplash.com)')

## 🖼️ Intro

This post explains how to use `PSCustomObject`s as function parameters. We compare the basic usage with an
advanced one using the `[PSTypeName()]` parameter attribute.

## 🗑️ Well-Known Workflow

So let's start with a common object definition how it is used with a function:

```powershell
$Rocinante = [PSCustomObject]@{
  Owner = 'Martian Congressional Republic Navy'
  Type = 'Light Frigate'
  Class = 'Corvette'
  Registry = 'ECF-270'
  HullNumber = '158'
  LengthInMeter = 46
  Name = 'Rocinante'
}
```

As you can see, a `PSCustomObject` has still the the same class type and just differs by its note properties.

```bash
> $Rocinante | Get-Member

   TypeName: System.Management.Automation.PSCustomObject

Name           MemberType    Definition
----           ----------    ----------
Equals         Method        bool Equals(System.Object obj)
GetHashCode    Method        int GetHashCode()
GetType        Method        type GetType()
ToString       Method        string ToString()
Class          NoteProperty  string Class=Corvette
HullNumber     NoteProperty  string HullNumber=158
LengthInMeter  NoteProperty  int LengthInMeter=46
Name           NoteProperty  string Name=Rocinante
Owner          NoteProperty  string Owner=Martian Congressional Republic Navy
Registry       NoteProperty  string Registry=ECF-270
Type           NoteProperty  string Type=Light Frigate

> $Rocinante.PSObject.TypeNames
System.Management.Automation.PSCustomObject
System.Object
```

So we can use the out object as an function parameter.

```powershell
function Invoke-Launch {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [PSCustomObject]$Ship
  )

  begin {}

  process {
    # Manual input validation for $Ship
    # test if all needed properties are present.

    $DockLength = 50
    if ($Ship.LengthInMeter -gt $DockLength) {
      Write-Error -Message "Ship doesn't fit in the docking station." -ErrorAction 'Stop'
    }
    # ...
    # ...
  }

  end {}
}
```

This common pattern could fail whenever someone changes your object properties. If the _LengthInMeter_ property is
missing you ran into an error. E.g.:

```console
> $Rocinante = [PSCustomObject]@{ foo = 'bar' }
> Invoke-Launch -Ship $Rocinante
```

{{< note >}}
Keep in mind - Because we are using here custom objects and not class instances, we can not use `Rocinante` as a
parameter type like `[Rocinante]$Ship` which would solve this immediately.
{{< /note >}}

To fix this we can use the `[PSTypeName()]` parameter attribute, to ensure an object with the correct type name is
used. This doesn't verify your parameters but minimize the risk for using invalid parameter objects.

## 🛡️ PSTypeName Usage

Let's first modify the object creation and use a custom type name.

```powershell
$Rocinante = [PSCustomObject]@{
  # You can use special property 'PSTypeName'
  # to set it implicit within the creation.
  PSTypeName = 'Ship.Corvette.LightFrigate'
  Owner = 'Martian Congressional Republic Navy'
  Type = 'Light Frigate'
  Class = 'Corvette'
  Registry = 'ECF-270'
  HullNumber = '158'
  LengthInMeter = 46
  Name = 'Rocinante'
}
# Legacy syntax for injection a custom type name
# $Rocinante.PSObject.TypeNames.insert(0,'Ship.Corvette.LightFrigate')
```

```bash
> $Rocinante | Get-Member

   TypeName: Ship.Corvette.LightFrigate

Name           MemberType    Definition
----           ----------    ----------
Equals         Method        bool Equals(System.Object obj)
GetHashCode    Method        int GetHashCode()
GetType        Method        type GetType()
ToString       Method        string ToString()
Class          NoteProperty  string Class=Corvette
HullNumber     NoteProperty  string HullNumber=158
LengthInMeter  NoteProperty  int LengthInMeter=46
Name           NoteProperty  string Name=Rocinante
Owner          NoteProperty  string Owner=Martian Congressional Republic Navy
Registry       NoteProperty  string Registry=ECF-270
Type           NoteProperty  string Type=Light Frigate

> $Rocinante.PSObject.TypeNames
Ship.Corvette.LightFrigate
System.Management.Automation.PSCustomObject
System.Object
```

Now we can replace the `[PSCustomObject]` parameter type by `[PSTypeName()]`

```powershell
function Invoke-Launch {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [PSTypeName('Ship.Corvette.LightFrigate')]
    [PSCustomObject]$Ship
  )

  begin {}

  process {
    $DockLength = 50
    if ($Ship.LengthInMeter -gt $DockLength) {
      Write-Error -Message "Ship doesn't fit in the docking station." -ErrorAction 'Stop'
    }
    # ...
    # ...
  }

  end {}
}
```

## 💭 Final Thoughts

Over time, your PowerShell functions become more and more complex. You will reach a point where you start using
objects as parameters. This is where the PSTypeName parameter attribute shown can help you.

In my experience, the ability to create custom classes _(introduced in PowerShell 5)_ is rarely used for this.

Most PowerShell users I know have a SysOp or DevOps background. Few come from software development and try to use
OOP paradigms and patterns.

Therefore I would also avoid using complex classes, especially if they use not only properties but also methods.

Like already mentioned `PSTypeName` just tests the used type name and not your definition details.
You should consider creating a your objects within a wrapper function to mimic a class constructor:

```powershell
function New-LightFrigate {
  [CmdletBinding()]
  [OutputType('Ship.Corvette.LightFrigate')]
  param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Registry,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$HullNumber,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Name
  )

  begin {}

  process {
    $Ship = [PSCustomObject]@{
      PSTypeName = 'Ship.Corvette.LightFrigate'
      Owner = 'Martian Congressional Republic Navy'
      Type = 'Light Frigate'
      Class = 'Corvette'
      Registry = $Registry
      HullNumber = $HullNumber
      LengthInMeter = 46
      Name = $Name
    }
    Write-Output $Ship
  }

  end {}
}

$Rocinante = New-LightFrigate -Name 'Rocinante' -Registry 'DE-MB2' -HullNumber '158'
```

## 📌 Appendix

Functions using the `[PSTypeName()]` validation should still define a parameter type. I've added the
`[PSCustomObject]` type for the _Ship_ parameter in _Invoke-Launch_.

You can also use a PSCustomObject collection in combination with `[PSTypeName()]` as function parameter:

```powershell
function Invoke-Launch {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [ValidateNotNullOrEmpty()]
    [PSTypeName('Ship.Corvette.LightFrigate')]
    [PSCustomObject[]]$Ship
  )

  begin {
    $DockLength = 50
  }

  process {
    foreach ($i in $Ship) {
      if ($Ship.LengthInMeter -gt $DockLength) {
        Write-Error -Message "Ship doesn't fit in the docking station." -ErrorAction 'Stop'
      }
      Write-Information -MessageData ('Launching Ship 🎇🚀 {0} ({1}) ...🪐' -f $i.Name, $i.Registry ) -InformationAction 'Continue'
    }

  }

  end {}
}

```

```bash
# Creating our ship objects.
> $Rocinante = New-LightFrigate -Name 'Rocinante' -Registry 'DE-MB2' -HullNumber '158'
> $XWing = New-LightFrigate -Name 'XWing1' -Registry 'DE-XW1' -HullNumber '43'
# Adding an invalid ship object for testing the validation.
> $InvalidShip = [PSCustomObject]@{ Name = 'Invalid'}
# Creating our ship collection.
> $LaunchGroup = @($Rocinante, $XWing, $InvalidShip)

# Calling Invoke-Launch with named parameter binding.
# An invalid array item blocks running the script for all other items. This is caused by the validation which runs
# prior the execution.
> Invoke-Launch -Ship $LaunchGroup
Invoke-Launch: Cannot bind argument to parameter 'Ship', because PSTypeNames of the argument do not match the
PSTypeName required by the parameter: Ship.Corvette.LightFrigate.

# Calling Invoke-Launch with passing the parameter from pipeline.
# This ensures processing the valid items.
> $LaunchGroup | Invoke-Launch
Launching Ship 🎇🚀 Rocinante (DE-MB2) ...🪐
Launching Ship 🎇🚀 XWing1 (DE-XW1) ...🪐
Invoke-Launch: The input object cannot be bound to any parameters for the command either because the command does
not take pipeline input or the input and its properties do not match any of the parameters that take pipeline input.
```
