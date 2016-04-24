
$critServices = @('Browser', 'DHCP', 'DNSCache', 'Eventlog', 'RpcSs', 
    'Server', 'lanmanserver', 'LmHosts', 'Lanmanworkstation', 'MpsSvc', 'WinRM')
    
Describe 'Services' {    
    Context 'Critical Services' {
        foreach ($svc in $critServices) {
            it "[$svc] Service running" {
                $svcInst = Get-Service -Name $svc
                $svcInst.Status | should be 'Running'    
            }            
        }
    }
    
    Context 'Non-Critical Automatic Servers' {
        $services = Get-Service | Where-Object { ($critServices -NotContains $_.Name ) -and
            ($_.StartType -eq 'Automatic') }
        
        foreach ($svc in $services) {
            it "[$($svc.Name)] Non-Critical Service Running" {
                $svc.Status | should be 'Running'
            }
        }
        
    }
}