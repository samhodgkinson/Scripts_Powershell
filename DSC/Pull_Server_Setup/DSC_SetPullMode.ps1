Configuration SetPullMode
{
    Node localhost
    {
        LocalConfigurationManager
        {
            ConfigurationMode = 'ApplyOnly'
            ConfigurationID = "d9257f0c-c234-4218-8d97-fedf5c94bef5"
            RefreshMode = 'Pull'
            DownloadManagerName = 'WebDownloadManager'
            DownloadManagerCustomData = @{
                ServerUrl = 'http://server1.domain.com:8080/PSDSCPullServer.svc';
                AllowUnsecureConnection = 'true' }
        }
    }
}

SetPullMode 

Set-DSCLocalConfigurationManager -Computer localhost -Path ./SetPullMode -Verbose


$guid = [guid]::NewGuid()