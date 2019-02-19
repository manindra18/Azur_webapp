// Powered by Infostretch 

timestamps {

node ('linux_slave') { 

	stage ('Webapp_CI - Checkout') {
 	 checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '60eab814-b753-44b9-b898-af64a923468c', url: 'https://github.com/manindra18/Azur_webapp.git']]]) 
	}
	stage ('Webapp_CI - Build') {
 	
// Unable to convert a build step referring to "hudson.plugins.ws__cleanup.PreBuildCleanup". Please verify and convert manually if required.
buildWrappers.'hudson.plugins.ws__cleanup.PreBuildCleanup'			
// Unable to convert a build step referring to "hudson.plugins.timestamper.TimestamperBuildWrapper". Please verify and convert manually if required.
buildWrappers.'hudson.plugins.timestamper.TimestamperBuildWrapper'
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
	}
}
}
