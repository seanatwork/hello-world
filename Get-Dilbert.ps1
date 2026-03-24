function get-dilbert{
[CmdletBinding()]
param
(
[string]$date =$((get-date).toshortdatestring()),
[switch]$Random
)

    if ($Random) { 
    
    [DateTime]$theMin = "4/16/1989"
    [DateTime]$theMax = [DateTime]::Now
 
    $theRandomGen = new-object random
    $theRandomTicks = [Convert]::ToInt64( ($theMax.ticks * 1.0 - $theMin.Ticks * 1.0 ) * $theRandomGen.NextDouble() + $theMin.Ticks * 1.0 )
    $day = new-object DateTime($theRandomTicks)
    
     } else {$day = get-date $date}
    [int[]]$TwoDigitMonths = 12,11,10
    if ($TwoDigitMonths -contains ($day.month)){
        $date = "$(($day).year)-$(($day).month)-$(($day).day)"
        }
        else{ $date = "$(($day).year)-0$(($day).month)-$(($day).day)"
        }
        $url = "https://fridayfun.net/dilbert-$date"

        $r = Invoke-WebRequest -Uri $url -TimeoutSec 30 -UseBasicParsing
       
        #Name of comic to set filename
        $file = "$date-dilbert"
        
        #Comic source to download - extract image URL from page
        $imagePattern = '<img[^>]+src="([^"]+\.webp[^"]*)"'
        if ($r.Content -match $imagePattern) {
            $imageUrl = $Matches[1]
            # Make URL absolute if it's relative
            if ($imageUrl -notmatch '^https?://') {
                $imageUrl = "https://fridayfun.net" + $imageUrl
            }
        } else {
            throw "Could not find comic image on the page"
        }
        #download the image
        $dilbertPath = "$HOME\Pictures\Dilbert"
        if (-not (Test-Path $dilbertPath)) {
            New-Item -ItemType Directory -Path $dilbertPath -Force | Out-Null
        }
        Invoke-WebRequest -uri $imageUrl -OutFile "$dilbertPath\$file.webp"
        Invoke-Item "$dilbertPath\$file.webp"
            }
