FROM python:alpine3.7
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENV PORT 7000
EXPOSE 7000
ENTRYPOINT [ "python" ]
CMD [ "app.py" ]