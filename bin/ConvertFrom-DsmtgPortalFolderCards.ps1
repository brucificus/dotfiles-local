#!/usr/bin/env pwsh

param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [PSObject[]] $inputObjects
)

# Such as from: https://api-mtg.dragonshield.com/api/v1/portalfolders/{portalFolderId}}/cards?provider={cardProvider}&pageSize={pageSize}}&pageNumber={pageNumber}}&orderBy={orderBy}}&lang={lang}
# Makes output that can be copy+pasted into TopDecked deck import... or just Dragon Shield's deck import. 🤦‍♂️

return `
    $inputObjects `
    | Expand-Property data,folderCards `
    | Select-Object -property quantity,cardName,expansionCode,expansionName,printing,friendlyId
