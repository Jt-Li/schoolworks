#!/bin/sh


# print HTTP header
# its best to print the header ASAP because 
# debugging is hard if an error stops a valid header being printed

echo Content-type: text/html
echo

# print page content

cat <<eof
<!DOCTYPE html>
<html lang="en">
<head>
<title>Browser IP, Host and User Agent</title>
</head>
<body>
Your browser is running at IP address: <b>$REMOTE_ADDR</b>
<p>
Your browser is running on hostname: <b>`host $REMOTE_ADDR | cut -d ' ' -f 5| sed 's/.$//' `</b>
<p>
Your browser identifies as: <b>$HTTP_USER_AGENT</b>
eof

# print all environment variables
# This is interpreted as HTML so we replace some chars by the equivalent HTML entity.
# Note this will not guarantee security in all contexts.




cat <<eof
</body>
</html>
eof

