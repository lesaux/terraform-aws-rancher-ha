command=`curl http://rancher.linuxdataflow.org/v1/projects/1a5/registrationtokens | jq -r '.data[].command'`
echo $command
command=`echo $command|sed s/--privileged/--privileged\ -e\ CATTLE_AGENT-IP=/g`
echo $command
