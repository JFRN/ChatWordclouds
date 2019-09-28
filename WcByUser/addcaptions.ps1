# Add filenames as caption to images in this folder

$files = Get-ChildItem "D:\Dev\osunigstats\WcByUser"
foreach ($f in $files) {
    $FileWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
    $FinalFilename = $FileWithoutExt + "-captioned" + ".png"
    magick convert $f.Name -pointsize 30 -background White label:$FileWithoutExt -gravity Center -append $FinalFilename
}