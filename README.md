# Stop-GCPInstances
Stop Gogole Clood Platform Instances insdie specific project by Instance name and zone.

From Google Cloud platform "Cloud Shell" run following commands:  
 ```bash
 bash Stop-Instances.sh 'aisarch-test-project' 'ProjectId' 'Json with comma separated instance list and zone' 'Schedule Cron format' 'TimeZone'
 ```
```bash
git clone https://github.com/bbz94/Stop-GCPInstances  
bash Stop-Instances.sh 'aisarch-test-project' '{"instances":"instance-2,instance-3","zone":"europe-north1-a"}' '0 18 * * *'  'Europe/London'  
```
