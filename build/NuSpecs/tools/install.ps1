param($rootPath, $toolsPath, $package, $project)

if ($project) {	
	# Create a backup of extisting umbraco config files
	$configPath = Join-Path (Split-Path $project.FullName -Parent) "\config"
    
    $ticks = (Get-Date).ToFileTime()
    $backupPath = Join-Path (Split-Path $project.FullName -Parent) "\App_Data\ConfigBackup\$ticks"
    $configBackupPath = Join-Path $backupPath "config"

    New-Item -ItemType Directory -Force -Path $configBackupPath

	Get-ChildItem -Path $configPath |
	   Where -filterscript {($_.Name.EndsWith("config"))} | Foreach-Object {
	    $newFileName = Join-Path $configBackupPath $_.Name
        New-Item -ItemType File -Path $newFileName -Force
	    Copy-Item $_.FullName $newFileName -Force
	   }
		
	# Create a backup of original web.config
	$projectDestinationPath = Split-Path $project.FullName -Parent
	$webConfigSource = Join-Path $projectDestinationPath "Web.config"
	Copy-Item $webConfigSource $backupPath -Force
	
	# Copy Config files from package to project folder
	$configFilesPath = Join-Path $rootPath "Content\Config\*.config"
	Copy-Item $umbracoFilesPath $configPath -Force
	
	# Copy Web.config from package to project folder
	$umbracoFilesPath = Join-Path $rootPath "UmbracoFiles\Web.config"
	Copy-Item $umbracoFilesPath $projectDestinationPath -Force
	
	# Open readme.txt file
	$DTE.ItemOperations.OpenFile($toolsPath + '\Readme.txt')
}