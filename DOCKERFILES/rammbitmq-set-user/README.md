###Build
docker build -t rabbit/user:v0.0.1 .

###Run
[frontend]  

docker run --name rabbitmq -p 15672:15672 rabbit/user:v0.0.1


[backend]  

docker run -d --name rabbitmq  -p 15672:15672 rabbit/user:v0.0.1


###Test
Visit by  http://IP_ADDRESS:15672/

