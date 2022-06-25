# README

This small project is an implementation of the code challenge provided https://salsify.github.io/line-server.html.

## How to run the application

The application was developed using Ruby on Rails 7.0.3 and Ruby 3.1.2, is dockerized and there are separate scripts to build and run the application. As such, to run the scripts Docker must be installed on the system. To build the project simply open the terminal, `cd` to the root of the repository and run the command `./build.sh`. 
To run the application, use the command `./run.sh <filepath>` where `filepath` is the path of the file you wish to be served by the application (i.e. `./run.sh ./sample.txt`). 
Alternatively you can use docker commands `LINE_SERVER_FILE=./sample.txt docker compose build` and `LINE_SERVER_FILE=./sample.txt docker compose up` to build and run the application respectively.

The application is served on `localhost:3000`. To reach the lines endpoint simply do a GET request to 
`http://localhost:300/lines/<line index>` 

## How does the system work?

The line server has a text file saved on the `app/assets/files` folder which is read when the line request is made.
To fetch the correct line, the file is read one line at a time and when it reaches the correct line, it will
return it as plain text with a status code 200. If the entire file is read without reaching the desired line, an error is raised and status code 413 is returned to the user. If the line provided is not an integer, the route returns 404.

No database is used. The path of the endpoint is defined on `routes.rb` and sent to the controller. There the line number is fetched and a call is sent to the file service. The file service will fetch the line of the file that is defined on the config file. The file service is defined on the controller via dependency injecton using `before_action :load_dependencies`.

## Performance

In terms of the file size of the served file, since the file is read line by line, the entire file does not need to load to memory.
As such bigger files will not lead to being out of memory. However, bigger files with more lines will still need to go through all the lines, so requesting a bigger line number, will take longer to fetch.

As for number of concurrent requests, as the file is immutable, only read requests are made and those can be made at the same time.
The bottleneck would be the I/O capacity of the hardware as well as the load balancer (e.g. Nginx). In terms of memory usage, each request would be using the memory required for a single line of the file at a time.

## Documentation

To develop this project, I looked at the following documentation:
- Rails tutorial to set up a running application: https://guides.rubyonrails.org/getting_started.html
- Sample Dockerfile and docker-compose for Rails apps: https://docs.docker.com/samples/rails/
- Comparing different read file methods on Ruby: https://tjay.dev/howto-working-efficiently-with-large-files-in-ruby/
- Functions for unit testing: https://guides.rubyonrails.org/testing.html

## Tools used

- Ruby on Rails 7.0.3
- Ruby 3.1.2
- Docker

I chose to use Docker as it allows to easily set up the application to run on almost any system, without the need to install many dependencies. Ruby on Rails was my pick because I was informed that Salsify mostly works with Ruby and with Rails being one of the most popular frameworks for it, I decided to give it a try.

## Time spent

In total, this project was made in around 5h with the setup included. With more time, I would first further optimize the file fetcher. Adding an endpoint to upload a new file and dividing the file into smaller files divided between certain line intervals, would allow faster fetch speeds for line requests with a larger number. Next I would increase the number of tests done accordingly, using mocks to unit test each class in isolation (which is allowed by the use of dependency injection), while also keeping integration tests to test the entire system. Next, a logging system would be required to keep track of requests and possible errors. Lastly, I would devote to investigating if the added logic of dividing a file in fixed size chunks instead of lines would be worth it. Chunks would require the search of the chunk for a `\n` character, but would limit the risk of big line sizes taking too much memory.

## Critiques

As I am not very experienced with Rails itself, there might be a more elegant way to use dependency injection on the Controller than what I did. Also since the project was generated automatically with a rails command, it has some unnecessary bloat.
