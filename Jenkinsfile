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
		cifsPublisher(publishers: [[configName: 'test_webserver', transfers: [[cleanRemote: true, excludes: '', flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '*.zip']], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false]])
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

set ChromeWebDriver="C:\\Python37\\Scripts"

python -m pytest --verbose --cov --html=Reports\\functest_report.html Tests\\functional_tests --webAppUrl http://localhost:8000/

c:\\sleep.exe 5 

taskkill -IM python.exe /F 
 """ 
	}
}
}
