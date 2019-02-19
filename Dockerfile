FROM azur_webapp:latest
LABEL maintainer="My App Service Container Images"

RUN apt-get update && apt-get install -y python3 python3-pip python3-dev && apt-get clean

RUN mkdir /code
WORKDIR /code
ADD . /code/
RUN cd Application/ && pip3 install -r requirements.txt

EXPOSE 8000 2222
CMD ["python3", "Application/manage.py", "runserver", "0.0.0.0:8000"]
