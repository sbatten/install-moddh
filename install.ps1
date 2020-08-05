# Install symbols
get-content "./mdh" | add-content /usr/share/X11/xkb/symbols/us


# Install variants
$variant = @"
<variant>
    <configItem>
        <name>mdh</name>
        <description>English (MDH)</description>
    </configItem>
</variant>
"@

[XML]$evdevXml = Get-Content /usr/share/X11/xkb/rules/evdev.xml
$variantNode = $evdevXml.CreateDocumentFragment()
$variantNode.InnerXml = $variant
($evdevXml.xkbConfigRegistry.layoutList.layout | ? { $_.configItem.name -eq 'us'  }).variantList.AppendChild($variantNode)
$evdevXml.Save("/usr/share/X11/xkb/rules/evdev.xml")

[XML]$baseXml = Get-Content /usr/share/X11/xkb/rules/base.xml
$variantNode = $baseXml.CreateDocumentFragment()
$variantNode.InnerXml = $variant
($baseXml.xkbConfigRegistry.layoutList.layout | ? { $_.configItem.name -eq 'us'  }).variantList.AppendChild($variantNode)
$baseXml.Save("/usr/share/X11/xkb/rules/base.xml")


$lstContent = get-content "/usr/share/X11/xkb/rules/evdev.lst"
$lstContent.Replace("! variant", "! variant`n  mdh             us: English (MDH)") | Out-File "/usr/share/X11/xkb/rules/evdev.lst"

$lstContent = get-content "/usr/share/X11/xkb/rules/base.lst"
$lstContent.Replace("! variant", "! variant`n  mdh             us: English (MDH)") | Out-File "/usr/share/X11/xkb/rules/base.lst"
