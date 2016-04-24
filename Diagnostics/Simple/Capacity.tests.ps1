$sysDriveLetter = $env:SystemDrive.Substring(0,1)
$freeSysDriveThreshold = 500
$freeNonSysDriveThreshold = 500
$freeNonSysDriveThresholdPct = .05
$freeMemThreshold = 500

Describe 'Capacity' {

    Context 'Memory' {
        it "Has $freeMemThreshold MB of RAM free" {
            $os = Get-CimInstance -ClassName 'win32_operatingsystem'
            $os.FreePhysicalMemory -ge $freeMemThreshold | should be $true
        }
    }

    Context 'Storage' {

        it "System drive [$sysDriveLetter] has $freeSysDriveThreshold MB free" {            
            $sysDrive = Get-Volume -DriveLetter $sysDriveLetter
            ($sysDrive.SizeRemaining / 1MB) -ge $freeSysDriveThreshold | should be $true
        }
        
        $volumes = Get-Volume | where DriveType -eq 'Fixed'
        foreach ($volume in $volumes | where DriveLetter -ne $sysDriveLetter) {
            it "Non-System drive [$($volume.DriveLetter)] has greater than $freeNonSysDriveThreshold MB free" {
                ($volume.SizeRemaining / 1MB) -ge $freeNonSysDriveThreshold | should be $true
            }
            
            it "Non-System drive [$($volume.DriveLetter)] has greater than $freeNonSysDriveThresholdPct% free" {
                ($volume.SizeRemaining / $volume.Size) -ge $freeNonSysDriveThresholdPct | should be $true
            }
        }
    }
}