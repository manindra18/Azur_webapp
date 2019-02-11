FROM ubuntu:16.04
LABEL maintainer="My App Service Container Images"

RUN apt-get update && apt-get install -y python python-pip python-dev && apt-get clean

RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN pip install -r requirements.txt
ADD . /code/
	
EXPOSE 8000 2222
CMD ["python", "/code/manage.py", "runserver", "0.0.0.0:8000"]
