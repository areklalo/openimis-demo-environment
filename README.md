# Description
Run openmrs distribution openmrs and mysql as docker containers.

## Requirements
  - Docker engine
  - Docker compose

## Development

### manageDemo script
To run the demo environment you need to execute (if it is the first time please add "-b" parameter to build Docker images):
```
$ ./scripts/manageDemo.sh -u
```

Or you can use docker-compose command in order to start both containers:
```
$ docker-compose up
```

Application will be accessible on 
* http://localhost:8089/openmrs (the app port can be change in the .env file)

Note: if you are using Docker Toolbox you need to replace `localhost` with the IP address of your docker machine,
which you can get by running:
```
$ docker-machine url
```

To stop the demo-environment execute (if you want to remove the docker volumes add "-v" parameter):
```bash
$ ./scripts/manageDemo.sh -s
```

### reloadModule script
In order to reload the OpenMRS module you can use prepared script:
```bash
$ ./scripts/reloadModule.sh
```
To display all possible options you can execute this script with the "-h" parameter.

For instance if you want to reload the module, execute:
```bash
$ ./scripts/reloadModule.sh -p {path_to_module}
```

Note: by default value of "-p" parameter is equal to `pwd` so if you will execute reloadModule 
from the module directory you don't have to set this parameter.

### manageDemo script
In order to manage the demo-environment you can use prepared script:
```bash
$ ./scripts/manageDemo.sh
```
To display all possible options you can execute this script with the "-h" parameter. 

For instance if you want to restart and clear the demo-environment, execute:
```bash
$ ./scripts/manageDemo.sh -rv
```

If you made any changes to the Dockerfile you should restart and rebuild docker image:
```bash
$ ./scripts/manageDemo.sh -rb
```
