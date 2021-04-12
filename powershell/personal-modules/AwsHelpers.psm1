function Import-AwsCredentialsProfileIntoEnv([string] $profile = "default") {
    Import-Module "$PSScriptRoot\Modules.psm1" -DisableNameChecking
    Ensure-ModuleInstallation psini -MinimumVersion 3.1.2 -MaximumVersion 3.1.2
    Import-Module "psini"

    $credentials = (Get-IniContent ~/.aws/credentials)[$profile]
    $env:AWS_ACCESS_KEY_ID = $credentials["aws_access_key_id"]
    $env:AWS_SECRET_ACCESS_KEY = $credentials["aws_secret_access_key"]
    $config = (Get-IniContent ~/.aws/config)["profile $profile"]
    $env:AWS_DEFAULT_REGION = $config.region
}
