function Get-UniqueAddressesByDay {
    param (
        [string]$csvDirectory
    )

    # Loome assotsiatiivse massiivi päevade kaupa unikaalsete aadresside jaoks
    $uniqueAddressesByDay = @{}

    # Loe CSV-failid kataloogist
    $csvFiles = Get-ChildItem -Path $csvDirectory -Filter "*.csv"

    foreach ($file in $csvFiles) {
        # Lugege CSV andmed failist
        $csvData = Import-Csv -Path $file.FullName -Delimiter ";" -Encoding UTF8

        # Filtreerige "trip" staatuse järgi ja gruppeerige kuupäeva alusel
        if ($csvData) {
            foreach ($row in $csvData) {
                # Kontrollige, kas rida vastab kriteeriumitele (staatus "trip")
                if ($row.Status -eq "trip" -and $row.Address -ne "") {
                    # Eemaldame aja kuupäevast (kuna kuupäeva formaat on '27/03/2024 17:57:07')
                    $date = ($row."Time (Europe/Tallinn)").Split(' ')[0]
                    
                    # Formaadime kuupäeva uuesti 'yyyy-MM-dd' kujule
                    $date = [datetime]::ParseExact($date, 'dd/MM/yyyy', $null).ToString('yyyy-MM-dd')
                    
                    # Lisame unikaalseid aadresse massiivi vastava kuupäeva jaoks
                    if (-not $uniqueAddressesByDay.ContainsKey($date)) {
                        $uniqueAddressesByDay[$date] = @()
                    }
                    
                    # Lisame unikaalsed aadressid
                    if (-not $uniqueAddressesByDay[$date].Contains($row.Address)) {
                        $uniqueAddressesByDay[$date] += $row.Address
                    }
                }
            }
        } else {
            Write-Host "Error: Ei suutnud lugeda andmeid failist $($file.FullName)"
        }
    }

    return $uniqueAddressesByDay
}

function Show-UniqueAddresses {
    param (
        [hashtable]$uniqueAddresses
    )

    # Kuva päevade kaupa unikaalsed aadressid
    foreach ($date in $uniqueAddresses.Keys | Sort-Object) {
        Write-Host "Kuupäev: $date"
        Write-Host "Unikaalsed aadressid:"
        $uniqueAddresses[$date] | ForEach-Object {
            Write-Host "- $_"
        }
        Write-Host ""
    }
}

# Põhiprogramm

# Defineeri CSV kausta tee
$csvDirectory = "C:\Users\kaspar\Documents\Powershell\ulesanne2024-05-08\CSV"

# Loeme CSV failid ja saame päevade kaupa unikaalsed aadressid
$uniqueAddresses = Get-UniqueAddressesByDay -csvDirectory $csvDirectory

# Näitame kasutajale valiku kuupäeva infot kuvada
while ($true) {
    $selectedDate = Read-Host "Sisestage kuupäev formaadis 'yyyy-MM-dd' (või enter, et lõpetada)"
    if ($selectedDate -eq "") {
        break
    }
    
    # Kontrollime, kas sisestatud kuupäev on olemas massiivis
    if ($uniqueAddresses.ContainsKey($selectedDate)) {
        Write-Host "Valitud kuupäeval ($selectedDate) leiti järgmised unikaalsed aadressid:"
        $uniqueAddresses[$selectedDate] | ForEach-Object {
            Write-Host "- $_"
        }
    } else {
        Write-Host "Kuupäeva ($selectedDate) kohta pole andmeid."
    }
}
