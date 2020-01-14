#download cromwell womtool
release_version=44
wget https://github.com/broadinstitute/cromwell/releases/download/${release_version}/cromwell-${release_version}.jar
wget https://github.com/broadinstitute/cromwell/releases/download/${release_version}/womtool-${release_version}.jar

#script validate
java -jar wdltool.jar validate grandsv.wdl

#inputs paras to inputs.json
java -jar wdltool.jar inputs grandsv.wdl > grandsv_inputs.json

#run
java -jar cromwell-44.jar run grandsv.wdl --inputs grandsv_inputs.json

java -jar cromwell-44.jar run myWorkflow.wdl #myWorkflow
java -jar cromwell-44.jar server #hello

java -Dconfig.file=/home/suyanan/cromwell/your.conf -jar cromwell-44.jar server
curl -X POST --header "Accept: application/json"\
    -v "localhost:8000/api/workflows/v1" \
    -F workflowSource=@timingWorkflow.wdl


######grandsv######
zip -r tasks.zip tasks

#run mode
java -jar cromwell-42.jar run grandsv.wdl --inputs grandsv_inputs.json --imports tasks.zip

#server mode
curl -X POST --header "Accept: application/json" -v "localhost:8089/api/workflows/v1" -F workflowSource=@grandsv.wdl -F "workflowInputs=@grandsv_inputs.json" -F "workflowDependencies=@tasks.zip"

http://localhost:8000/api/workflows/v1/8d18b845-7143-4f35-9543-1977383b7d2f/timing #replace your workflow id

#huaweiyun
#mount sfs
mount -t nfs -o vers=3,timeo=600,nolock sfs-nas1.cn-north-1.myhuaweicloud.com:/share-60596fe7 /sfs
curl -X POST --header "Accept: application/json" -v "http://192.168.0.200:7161/api/workflows/v1" -F "workflowSource=@grandsv.wdl" -F "workflowInputs=@grandsv_inputs.json" -F "workflowOptions=@cci.options" -F "workflowDependencies=@tasks.zip"

##hanwell test
gcs sub wdl grandsv.wdl -i grandsv_inputs.json -o cci.options -d tasks.zip -n grandsv -s gcs-env-grand-med-research






