// Powered by Infostretch 

timestamps {

node ('linux_slave') { 

	stage ('Webapp_CI - Checkout') {
 	 checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '60eab814-b753-44b9-b898-af64a923468c', url: 'https://github.com/manindra18/Azur_webapp.git']]]) 
	}
	stage ('Webapp_CI - Build') {
 	
// Unable to convert a build step referring to "hudson.plugins.ws__cleanup.PreBuildCleanup". Please verify and convert manually if required.
//buildWrappers.'hudson.plugins.ws__cleanup.PreBuildCleanup'
// Unable to convert a build step referring to "hudson.plugins.timestamper.TimestamperBuildWrapper". Please verify and convert manually if required.
//buildWrappers.'hudson.plugins.timestamper.TimestamperBuildWrapper'
// Shell build step
sh """ 
cd $WORKSPACE

zip -r Azur_webapp.zip * -x *.zip *.pyc *__pycache__*

sleep 10

sudo pip3 install -r Application/requirements.txt && sudo pip3 install pytest pytest-html pytest-cov

if [ ! -d "Reports" ]; then

mkdir Reports

fi

sudo python3.6 -m pytest --verbose --cov --html=Reports/unittest_report.html Tests/unit_tests/ 
 """
		archiveArtifacts allowEmptyArchive: false, artifacts: '*.zip', caseSensitive: true, defaultExcludes: true, excludes: 'Reports', fingerprint: false, onlyIfSuccessful: false 
		sleep 5
		cifsPublisher(publishers: [[configName: 'pipeline_share', transfers: [[cleanRemote: true, excludes: '', flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '*.zip']], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false]])
		sleep 5
		publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'Reports', reportFiles: 'unittest_report.html', reportName: 'Unit Test Report', reportTitles: 'Unit Test Report'])
	}
}
	node ('windows') { 

	stage ('Webapp_SelFuncTest - Build') {
// Batch build step
bat """ 
c:\\unzip.exe -o Azur_webapp.zip

c:\\sleep.exe 5

pip3 install -r Application\\requirements.txt

pip3 install pytest pytest-html pytest-cov selenium

c:\\sleep.exe 5

start /min python Application\\manage.py runserver 0.0.0.0:8000

c:\\sleep.exe 5

python -m pytest --verbose --cov --html=Reports\\functest_report.html Tests\\functional_tests --webAppUrl http://localhost:8000/

c:\\sleep.exe 5 

tasklist | find /i "python.exe" && taskkill /im python.exe /F || echo process "python.exe" not running.
 """ 
		publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'Reports', reportFiles: 'functest_report.html', reportName: 'Functional Test Report', reportTitles: 'Functional Test Report'])
	}
}
node ('linux_slave') { 

	stage ('Webapp_Container - Build') {
// Shell build step
sh """ 
sudo docker build -t 'azur_webapp:latest' .
sudo docker rm -f azure_webapp
sudo docker create --name azur_webapp -p 8000:8000 -p 2222:2222 azur_webapp:latest && sudo docker start azur_webapp
 """ 		
	}
}
node ('windows') { 

	stage ('Webapp_SelRegression - Build') {
// Batch build step
bat """ 
c:\\unzip.exe -o Azur_webapp.zip

c:\\sleep.exe 5

pip3 install --upgrade robotframework-seleniumlibrary
pip3 install --upgrade robotframework-selenium2library
pip3 install robotframework-ride --trusted-host pypi.org

c:\\sleep.exe 5

python -m robot -d Reports\\regression --variable URL:"http://192.168.4.81:8000/login/" Tests\\regression_tests\\Azur-webapp-login.robot

c:\\sleep.exe 5 

tasklist | find /i "python.exe" && taskkill /im python.exe /F || echo process "python.exe" not running. 
 """ 
		publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'Reports\\regression', reportFiles: 'report.html', reportName: 'Regression Test Report', reportTitles: 'Regression Test Report'])
		publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'Reports\\regression', reportFiles: 'log.html', reportName: 'Regression Test Log', reportTitles: 'Regression Test Log'])
	}
}
node ('linux_slave') { 

	stage ('Webapp_image - upload to GCR') {
// Shell build step
sh """
cat $HOME/devops-gcp.json | sudo docker login -u _json_key --password-stdin https://gcr.io
sleep 5
sudo docker tag azur_webapp:latest gcr.io/devops-232312/azur_webapp:v1.${BUILD_NUMBER}
sudo docker push gcr.io/devops-232312/azur_webapp:v1.${BUILD_NUMBER}
sudo docker rmi gcr.io/devops-232312/azur_webapp:v1.${BUILD_NUMBER}
 """
	}
}
node ('linux_slave') { 

	stage ('Webapp_Deploy - Deploy the webApp on GCE') {
// Shell build step
sh """
USER_STATUS=`gcloud config list account --format "value(core.account)"`
echo \${USER_STATUS}
if [ ! -z \${USER_STATUS} ]; then
	echo "user is already logged in..."
else
        echo "user is not logged in, logging in now"
	gcloud auth activate-service-account jenkins-auth@devops-232312.iam.gserviceaccount.com --key-file=$HOME/devops-gcp.json --project=devops-232312
fi

gcloud compute --project "devops-232312" ssh --zone "us-central1-c" "forseti-server-vm-fs-123" --command "sudo usermod -aG docker \$USER"
gcloud compute --project "devops-232312" ssh --zone "us-central1-c" "forseti-server-vm-fs-123" --command "cat \$HOME/devops-gcp.json | docker login -u _json_key --password-stdin https://gcr.io"
gcloud compute --project "devops-232312" ssh --zone "us-central1-c" "forseti-server-vm-fs-123" --command "for i in \$(sudo docker ps -a --format {{.Names}} | grep -iE 'azur_webapp'); do sudo docker rm -f \$i; done"
gcloud compute --project "devops-232312" ssh --zone "us-central1-c" "forseti-server-vm-fs-123" --command "sudo docker create --name azur_webapp -p 8000:8000 -p 2222:2222 gcr.io/devops-232312/azur_webapp:v1.${BUILD_NUMBER} && sudo docker start azur_webapp"
 """
	}
}
}
