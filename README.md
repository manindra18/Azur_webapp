# Azur_webapp CI/CD implimentation:
===================================

An webapp to test the CI/CD deployment in jenkins with unit tests, functional and regression test used pytest and robot frameworks.

To build a Docker continer :
------------------------------
docker build -t 'azur_webapp:latest' .

docker rm -f test_webapp

docker create --name test_webapp -p 8000:8000 -p 2222:2222 azur_webapp:latest && docker start test_webapp

To start the django server in background in windows:
----------------------------------------------------
start /min python Application/manage.py runserver 0.0.0.0:8000

To run unit tests using pytest:
-------------------------------
python -m pytest --verbose --cov --html=Reports/unittest_report.html Tests/unit_tests/

To run functinal tests using pytest + selenium:
-----------------------------------------------
python -m pytest --verbose --cov --html=Reports/functest_report.html Tests\functional_tests --webAppUrl http://localhost:8000/

To kill all the python processes in windows without throwing error if the process not found:
--------------------------------------------------------------------------------------------
tasklist | find /i "python.exe" && taskkill /im python.exe /F || echo process "python.exe" not running.

Jenkins Execute windows batch command content for webapp selenium testing:
--------------------------------------------------------------------------
c:\unzip.exe -o Azur_webapp.zip

c:\sleep.exe 5

pip3 install -r Application/requirements.txt

pip3 install pytest pytest-html pytest-cov selenium

c:\sleep.exe 5

start /min python Application/manage.py runserver 0.0.0.0:8000

c:\sleep.exe 5

python -m pytest --verbose --cov --html=Reports\functest_report.html Tests\functional_tests --webAppUrl http://localhost:8000/

c:\sleep.exe 5 

tasklist | find /i "python.exe" && taskkill /im python.exe /F || echo process "python.exe" not running.

Robot framework packages needed and execution of regression tests:
-------------------------------------------------------------------
pip install --upgrade robotframework-seleniumlibrary

pip install --upgrade robotframework-selenium2library

pip install robotframework-ride --trusted-host pypi.org

python -m robot -d Reports\regression Tests\regression_tests\Azur-webapp-login.robot

To get the gcloud logged in user name:
---------------------------------------
gcloud config list account --format "value(core.account)"

To authenticate docker to push the local image to the GCR:
-----------------------------------------------------------
cat $HOME/<key.json> | docker login -u _json_key --password-stdin https://gcr.io

Google auth activate service account on client machine:
--------------------------------------------------------
gcloud auth activate-service-account <service_account> --key-file=$HOME/<key.json> --project=<project_ID>

To execute SSh commands using gcloud tool
------------------------------------------
- To add the normal user to docker group

gcloud compute --project "<project_ID>" ssh --zone "us-central1-c" "<instance_name>" --command "sudo usermod -aG docker $USER"

- To login to GRC to pull the image

gcloud compute --project "<project_ID>" ssh --zone "us-central1-c" "<instance_name>" --command "cat $HOME/<key.json> | docker login -u _json_key --password-stdin https://gcr.io"

- To start a container on GCP compute instance 

gcloud compute --project "<project_ID>" ssh --zone "us-central1-c" "<instance_name>" --command "sudo docker create --name azur_webapp -p 8000:8000 -p 2222:2222 gcr.io/devops-232312/azur_webapp:${BUILD_NUMBER} && sudo docker start azur_webapp"
