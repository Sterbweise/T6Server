FROM debian:bullseye-slim

# Install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy the entire T6Server project into the container
COPY . /app/T6Server

WORKDIR /app/T6Server

# Move testsValidation.sh to the root of the project
RUN mv .config/utility/dev/testsValidation.sh .

# Make sure scripts are executable
RUN chmod +x testsValidation.sh

# Run tests when container starts
CMD ["./testsValidation.sh"]
