SELECT PROPERTY('ServerName')
	,@@version
	,PROPERTY('ProductName')
	,PROPERTY('ProductVersion')
	,PROPERTY('MachineName')
	,PROPERTY('Platform')
	,PROPERTY('PlatformVer')
	,DB_PROPERTY('Name')
	,DB_PROPERTY('File')
	,PROPERTY('PageSize')
	,DB_PROPERTY('LogName')
	,PROPERTY('ConsoleLogFile')
	,PROPERTY('Language')
	,PROPERTY('CharSet')
	,DB_PROPERTY('NcharCharSet')
	,DB_PROPERTY('Collation')
	,DB_PROPERTY('Capabilities')
	,PROPERTY('IsNetworkServer')
	,PROPERTY('IsJavaAvailable')
	,PROPERTY('DefaultCollation')
	,PROPERTY('DefaultNcharCollation')
	,PROPERTY('IsFipsAvailable')
	,PROPERTY('FipsMode')
	,PROPERTY('Tempdir')
	,PROPERTY('ConnsDisabled')
	,PROPERTY('QuittingTime')
	,PROPERTY('RememberLastStatement')