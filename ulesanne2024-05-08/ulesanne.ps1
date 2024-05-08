# Paigaldame ImportExcel mooduli, kui see ei ole veel paigaldatud
if (-not (Get-Module -Name ImportExcel -ListAvailable)) {
    Write-Host "Paigaldan ImportExcel mooduli..."
    Install-Module -Name ImportExcel -Scope CurrentUser -Force
}

# Impordime ImportExcel mooduli
Write-Host "Importin ImportExcel mooduli..."
Import-Module -Name ImportExcel

# Määrame kaustad Exceli ja CSV failide jaoks
$excelDirectory = "C:\Users\kaspar\Documents\Powershell\ulesanne2024-05-08\XLS"
$csvDirectory = "C:\Users\kaspar\Documents\Powershell\ulesanne2024-05-08\CSV"

# Hangime kõik Exceli failid Exceli kaustast
$excelFiles = Get-ChildItem -Path $excelDirectory -Filter *.xlsx | Where-Object { $_.Name -notmatch '\d{4}-\d{2}-\d{2}_Sinotrack-ST-903\.xlsx' }

# Läbime iga Exceli faili
foreach ($file in $excelFiles) {
    # Hangime failinimi ilma laiendita
    $fileNameWithoutExtension = $file.BaseName

    # Ekstraktime kuupäeva failinimest
    if ($fileNameWithoutExtension -match '.*?(\d{2}-\d{2}-\d{4})') {
        $newFileDate = $matches[1]  # Matches list contains the captured date
        $newExcelFileName = "${newFileDate}_Sinotrack-ST-903.xlsx"
        $newCsvFileName = "${newFileDate}_Sinotrack-ST-903.csv"
    } else {
        Write-Host "Viga: ei suutnud kuupäeva failinimest leida $($file.Name)"
        continue
    }

    # Määrame uue faili tee ümbernimetatud Exceli failile
    $newExcelFilePath = Join-Path -Path $excelDirectory -ChildPath $newExcelFileName

    # Kopeerime Exceli fail uue nimega
    try {
        Copy-Item -Path $file.FullName -Destination $newExcelFilePath -ErrorAction Stop
        Write-Host "Fail $($file.Name) kopeeritud uueks failiks $newExcelFileName"
    } catch {
        Write-Host "Viga: Ei suutnud kopeerida faili $($file.Name)"
        continue
    }

    # Importime andmed kopeeritud Exceli failist
    try {
        $excelData = Import-Excel -Path $newExcelFilePath
    } catch {
        Write-Host "Viga: Ei suutnud importida andmeid failist $newExcelFileName"
        continue
    }

    # Määrame uue faili tee CSV failile
    $newCsvFilePath = Join-Path -Path $csvDirectory -ChildPath $newCsvFileName

    # Eksportime Exceli andmed CSV faili
    try {
        $excelData | Export-Csv -Path $newCsvFilePath -Delimiter ";" -NoTypeInformation
        Write-Host "Andmed eksporditud faili $newCsvFileName"
    } catch {
        Write-Host "Viga: Ei suutnud eksportida andmeid failile $newCsvFileName"
    }
}
