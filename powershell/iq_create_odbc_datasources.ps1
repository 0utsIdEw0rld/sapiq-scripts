$username=$env:UserName
$passwd="dummy"
$port="48090"
$ODBC_CONNECTIONS = @{
    "DATASOURCE_NAME"       = "SERVERNAME" 
}
foreach ($datasource in $ODBC_CONNECTIONS.GetEnumerator()) { 
    $dsn=$datasource.Name.trim()
    $srv=$datasource.Value.trim()
    iqdsn -pet a -y -w   $dsn -c"pwd=""$passwd"";uid=$username;eng=$srv;links=tcpip(host=$srv.bisinfo.org:$port);IDLE=10;autoprecommit=true;CON=$username"
    iqdsn -pet a -y -ws  $dsn -c"pwd=""$passwd"";uid=$username;eng=$srv;links=tcpip(host=$srv.bisinfo.org:$port);IDLE=10;autoprecommit=true;CON=$username"
}
