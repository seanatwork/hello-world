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
        $url = "http://dilbert.com/strip/$date"

        $r = Invoke-WebRequest -Uri $url -TimeoutSec 30 -UseBasicParsing
       
        #Name of comic to set filename
        $file = $date + $($r.IMAGES | ? Class -eq "img-responsive img-comic").alt
        
        #Comic source to download
        $str = ($r.links | ? title -Like "*Click*").outerhtml
        $str -match "src=.+`"" | Out-Null
        $str = $Matches.Values
        $image = $str.split('=')[1]
        #download the image
        Invoke-WebRequest -uri $($image.Replace('"',"") +'.gif') -OutFile $HOME\documents\dilbert\$file.gif
        Invoke-Item $HOME\documents\dilbert\$file.gif
            }
