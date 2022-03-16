---
title: 'Parameter validation with PSTypeName'
date: 2022-03-16T09:24:56+01:00
draft: true

categories: ['PowerShell']
tags: ['parameter validation']
# lastmod: 2022-03-16T09:24:56+01:00
# showDateUpdated: true

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

If you're using `PSCustomObject`s with customized _TypeNames_ you could validate them with additional parameter
attributes.

## Well-Known Workflow

So let's start with a common object definition how it is used with a function:

```powershell
$Rocinante = [PSCustomObject]@{
  Owner = 'Martian Congressional Republic Navy'
  Type = 'Light Frigate'
  Class = 'Corvette'
  Registry = 'ECF-270'
  HullNumber = '158'
  Length = '46'
}
```

As you can see, a `PSCustomObject` has still the the same class type and just differs by its note properties.

```bash
> $Rocinante | Get-Member

   TypeName: System.Management.Automation.PSCustomObject

Name        MemberType   Definition
----        ----------   ----------
Equals      Method       bool Equals(System.Object obj)
GetHashCode Method       int GetHashCode()
GetType     Method       type GetType()
ToString    Method       string ToString()
Class       NoteProperty string Class=Corvette
HullNumber  NoteProperty string HullNumber=158
Length      NoteProperty string Length=46
Owner       NoteProperty string Owner=Martian Congressional Republic Navy
Registry    NoteProperty string Registry=ECF-270
Type        NoteProperty string Type=Light Frigate

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

    $DockLength = '50'
    if ($Ship.Length > $DockLength) {
      Write-Error -Message "Ship doesn't fit in the docking station." -ErrorAction 'Stop'
    }
    # ...
    # ...
  }

  end {}
}
```

This common pattern could fail whenever someone changes your object properties. If the _Length_ property is missing you ran into an error. E.g.:

```console
> $Rocinante = [PSCustomObject]@{ foo = 'bar' }
> Invoke-Launch -Ship $Rocinante
```

{{< note >}}
Keep in mind - Because we are using here custom objects and not class instances, we can not use `Rocinante` as a parameter type like `[Rocinante]$Ship` which would solve this immediately.
{{< /note >}}

To fix this we can use the `[PSTypeName()]` parameter attribute, to ensure an object with the correct type name is used. This doesn't verify your parameters but minimize the risk for using invalid parameter objects.

## PSTypeName Usage

Let's first modify the object creation and use a custom type name.

```powershell
$Rocinante = [PSCustomObject]@{
  # You can use special property 'PSTypeName'
  # to set it implicit within the creation.
  PSTypeName = 'Rocinante'
  Owner = 'Martian Congressional Republic Navy'
  Type = 'Light Frigate'
  Class = 'Corvette'
  Registry = 'ECF-270'
  HullNumber = '158'
  Length = '46'
}
# Legacy syntax for injection a custom type name
# $Rocinante.PSObject.TypeNames.insert(0,'Rocinante')
```

```bash
> $Rocinante | Get-Member

   TypeName: Rocinante

Name        MemberType   Definition
----        ----------   ----------
Equals      Method       bool Equals(System.Object obj)
GetHashCode Method       int GetHashCode()
GetType     Method       type GetType()
ToString    Method       string ToString()
Class       NoteProperty string Class=Corvette
HullNumber  NoteProperty string HullNumber=158
Length      NoteProperty string Length=46
Owner       NoteProperty string Owner=Martian Congressional Republic Navy
Registry    NoteProperty string Registry=ECF-270
Type        NoteProperty string Type=Light Frigate

> $Rocinante.PSObject.TypeNames
Rocinante
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
    [PSTypeName('Rocinante')]$Ship
  )

  begin {}

  process {
    $DockLength = '50'
    if ($Ship.Length > $DockLength) {
      Write-Error -Message "Ship doesn't fit in the docking station." -ErrorAction 'Stop'
    }
    # ...
    # ...
  }

  end {}
}
```

## Final Thoughts

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
  param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Name,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Registry,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$HullNumber
  )

  begin {}

  process {
    $Ship = [PSCustomObject]@{
      PSTypeName = $Name
      Owner = 'Martian Congressional Republic Navy'
      Type = 'Light Frigate'
      Class = 'Corvette'
      Registry = $Registry
      HullNumber = $HullNumber
      Length = '46'
    }
    Write-Output $Ship
  }

  end {}
}

$Rocinante = New-LightFrigate -Name 'Rocintante' -Registry 'DE-MB2' -HullNumber '158'
```
