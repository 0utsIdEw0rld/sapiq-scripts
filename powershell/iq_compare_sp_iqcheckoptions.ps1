#run set_daily.ps1 before the below code.
#
# This script queries sp_iqcheckoptions against two servers. Output is stored in files that are later compared using WinMerge
#
$RH7_vs_RH8 = @{
    "PRODRH7"     = "PRODRH8" 
}
$output_path = "j:\sybaseiq\"
$partial_file_name = "_sp_iqcheckoptions.csv"
$query = "select * from sp_iqcheckoptions() order by option_name"

foreach ($rh in $RH7_vs_RH8.GetEnumerator()) { 
    $rh7 = $rh.Name.trim()
    $rh8 = $rh.Value.trim()
    $rh7_filename = -join($output_path, $rh7, $partial_file_name)
    $rh8_filename = -join($output_path, $rh8, $partial_file_name)
    dbisql -c "dsn=$rh7" -nogui -onerror continue  "$query; output to '$rh7_filename' format text escapes on escape character '\' delimited by ','"
    dbisql -c "dsn=$rh8" -nogui -onerror continue  "$query; output to '$rh8_filename' format text escapes on escape character '\' delimited by ','"
    & "C:\Program Files\WinMerge\WinMergeU.exe" $rh7_filename $rh8_filename
}
