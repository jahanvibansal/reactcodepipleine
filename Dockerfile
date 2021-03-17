FROM node:alpine as builder
# set working directory
WORKDIR /react-app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
#COPY package-lock.json ./
RUN npm install --silent
RUN npm install react-scripts@3.4.1 -g --silent


# add app
COPY . ./

# store the build into build object
RUN npm run build

#Create a new container from a linux base image that has the aws-cli installed
FROM amazon/aws-cli:2.0.6

#Using the alias defined for the first container, copy the contents of the build folder to this container
COPY --from=builder /react-app/build .

#Set the default command of this container to push the files from the working directory of this container to our s3 bucket 
CMD ["s3", "sync", "./", "s3://terraforms3bucket1234"] 

#docker build --tag react-app --file Dockerfile . 
# docker run   --env AWS_DEFAULT_REGION=us-east-1 react-app
