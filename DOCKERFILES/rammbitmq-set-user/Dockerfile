FROM rabbitmq

# Define environment variables.
ENV RABBITMQ_USER user
ENV RABBITMQ_PASSWORD password

ADD init.sh /init.sh
EXPOSE 15672

# Define default command
CMD ["/init.sh"]
