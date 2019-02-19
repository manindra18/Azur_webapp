pipeline {
  agent any
  stages {
    stage('Git Pull') {
      steps {
        echo 'Pulled the code from git repository'
      }
    }
    stage('Build') {
      steps {
        node(label: 'linux_slave')
        sh '''cd $WORKSPACE

zip -r Azur_webapp.zip * -x *.zip *.pyc \\*__pycache__\\*

sleep 10

sudo pip3 install -r Application/requirements.txt && sudo pip3 install pytest pytest-html pytest-cov

if [ ! -d "Reports" ]; then

mkdir Reports

fi

sudo python3.6 -m pytest --verbose --cov --html=Reports/unittest_report.html Tests/unit_tests/
'''
        archiveArtifacts(artifacts: '*.zip', excludes: 'Reports')
      }
    }
  }
}