# sxapi-example

Example of a micro-service application using startx sxapi s2i builder [startx/sxapi](https://hub.docker.com/r/startx/sxapi) (using [source-to-image](https://github.com/openshift/source-to-image)).
See [using sxapi builder](https://sxapi-core.readthedocs.io/guides/USE_docker#using-openshift) to learn on how to build this example.

The easyest way to start building you own API resource is to fork this repository and start to personalize `sxapi.yaml`.
Follow the [sxapi configuration guide](https://sxapi-core.readthedocs.io/guides/2.Configure) to learn
how to create your own microservice endpoints winthin a minute.

## Running this example using docker

### Docker requirements

- You must have access to a running `docker` daemon with access to the dockerhub public registry.
  If you don't have docker runtime, please follow [docker](https://docs.docker.com/)
  installation guide for [CentOS](https://docs.docker.com/install/linux/docker-ce/centos/),
  [RHEL](https://docs.docker.com/install/linux/docker-ee/rhel/),
  [Windows](https://docs.docker.com/docker-for-windows/install/)
  or [MacOS](https://docs.docker.com/docker-for-mac/install/).
- You must also have `git` tool installed to clone and work with application source code.

### Create application using Dockerfile

```bash
git clone https://github.com/startxfr/sxapi-example.git
cd sxapi-example
docker build -t sxapi-example .
docker run -p 8080:8080 sxapi-example
```

### Docker strategy workflow

```text
 .---------------------.    .----------------------------.            .-,(  ),-.
 |     base image      |    | Source code (application)  |         .-(          )-.
 |---------------------|    |----------------------------|        (    internet    )
 | startx/sxapi:latest |    | local copy (sxapi-example) |         '-(          ).-'
 '---------------------'    '----------------------------'             '-.( ).-'
            \                            /                                 ^
             \       docker build       /                                  |
              \      (Dockerfile)      /                                   |
               v                      v                                    |
               .----------------------.                        .-----------------------.
               |  application image   |        docker run      | application container |
               |----------------------|----------------------->|-----------------------|
               | sxapi-example        |                        | sxapi-example         |
               '----------------------'                        '-----------------------'
```

## Running this example using s2i

### S2i requirements

Install and configure s2i tools. If you don't have it yet, please follow [source-to-image](https://github.com/openshift/source-to-image)
installation guide for [Linux](https://github.com/openshift/source-to-image#for-linux), [Windows](https://github.com/openshift/source-to-image#for-Windows)
or [MacOS](https://github.com/openshift/source-to-image#for-mac).

### Create application using s2i build

```bash
s2i build https://github.com/startxfr/sxapi-example startx/sxapi sxapi-example
docker run -p 8080:8080 sxapi-example
```

### S2I strategy workflow

```text
 .---------------------.  .-------------------------------------------.
 |     base image      |  |         Source code (application)         |
 |---------------------|  |-------------------------------------------|
 | startx/sxapi:latest |  | https://github.com/startxfr/sxapi-example |
 '---------------------'  /-------------------------------------------'
            |            /
            v           /
 .---------------------v     .----------------------.
 |      s2i build      |     |  application image   |
 |---------------------|---->|----------------------|
 | sxapi-example       |     | sxapi-example:latest |
 '---------------------'     '----------------------'
                                         |
                                         v
                             .-----------------------.            .-,(  ),-.
                             | application container |         .-(          )-.
          docker run  ------>|-----------------------|------->(    internet    )
                             | sxapi-example         |         '-(          ).-'
                             '-----------------------'             '-.( ).-'
```

## Running this example using openshift

### Openshift requirements

- Configure an openshift cluster with a minimum v3.5 release. 
  User must be a `system:authenticated` user with at least default associated roles (default behavior). 
  you can use SaaS solution [openshift online](https://manage.openshift.com/) to get this environement within a minute.
- Connect to your openshift cluster.
  
  ```bash
  # <login> Your openshift username
  # <pwd> Your openshift password
  # <openshift_api> Your openshift master API hostname (ex: https://mymaster.openshift.example.com:8443)
  oc login -u <login> -p <pwd> <openshift_api>
  ```

- Create a project for this application example

  ```bash
  # <project_name> The project name
  oc new-project <project_name>
  ```

### Create application using the build template

```bash
oc process -f https://raw.githubusercontent.com/startxfr/sxapi-example/master/openshift-template-build.yaml \
   -v APP_NAME=sxapi1 \
   -v APP_TYPE=example \
   -v SOURCE_BRANCH=master \
   -v WEBHOOK_TOKEN=sxapi-example-e7h91Yka4p7qD24 | \
oc create -f -
```

### Build strategy workflow

```text
 .---------------------. .----------------------.
 |    Builder image    | |        Image         |
 |---------------------| |----------------------|
 | startx/sxapi:latest | | sxapi-example:latest |
 '---------------------' '----------------------'
            |            ^          |
            v           /           v
 .---------------------/    .---------------.    .---------------.    .---------------.
 |    Build config     |    | Deploy config |    |      Pod      |    |    Service    |
 |---------------------|    |---------------|--->|---------------|--->|---------------|
 | sxapi-example       |    | sxapi-example |    | sxapi-example |    | sxapi-example |
 '---------------------'    '---------------'    '---------------'    '---------------'
            ^                                                                 |
            |                                                                 v
 .-------------------------------------------.       .-,(  ),-.       .---------------.
 |         Source code (application)         |    .-(          )-.    |     Route     |
 |-------------------------------------------|   (    internet    )<--|---------------|
 | https://github.com/startxfr/sxapi-example |    '-(          ).-'   | sxapi-example |
 '-------------------------------------------'        '-.( ).-'       '---------------'

```

### Create application using the pipeline template

```bash
oc process -f https://raw.githubusercontent.com/startxfr/sxapi-example/master/openshift-template-pipeline.yaml \
   -v APP_NAME=sxapi2 \
   -v APP_TYPE=example \
   -v SOURCE_BRANCH=master \
   -v WEBHOOK_TOKEN=sxapi-example-f5H34pASlaiZ27c | \
oc create -f -
```

### Pipeline strategy workflow

```text
.----------.     .---------------------. .----------------------.
|          |     |    Builder image    | |        Image         |
|          |     |---------------------| |----------------------|
|          |     | startx/sxapi:latest | | sxapi-example:latest |
|          |     '---------------------' '----------------------'
|          |                |            ^           |
|          |                v           /            v
|          |     .--------------------./  .--------------------.   .--------------------.
|          |     |    Build config    |   |   Deploy config    |   |        Pod         |
|          |---->|--------------------|   |--------------------|-->|--------------------|
|          |     | sxapi-example-test |   | sxapi-example-test |   | sxapi-example-test |
|          |     '--------------------'   '--------------------'   '--------------------'
|          |                ^                                                 |
|          |                |                                                 v
|          |     .-------------------------------------------.     .--------------------.
|    P     |     |         Source code (application)         |     |      Service       |
|    I     |     |-------------------------------------------|     |--------------------|
|    P     |     | https://github.com/startxfr/sxapi-example |     | sxapi-example-test |
|    E     |     '-------------------------------------------'     '--------------------'
|    L     |                                                                  |
|    I     |                                                                  v
|    N     |                                                       .--------------------.
|    E     |     .-------------------.                             |       Route        |
|          |     |     Approval      |                             |--------------------|
|          |---->|-------------------|                             | sxapi-example-test |
|          |     | manual validation |                             '--------------------'
|          |     '-------------------'            .-,(  ),-.                  |
|          |                                   .-(          )-.               |
|          |                                  (    internet    )<-------------'
|          |                                   '-(          ).-'              |
|          |     .----------------------.          '-.( ).-'                  |
|          |     |        Image         |                          .--------------------.
|          |     |----------------------|                          |       Route        |
|          |     | sxapi-example:latest |                          |--------------------|
|          |     '----------------------'                          | sxapi-example-run  |
|          |                 |            .-------------------.    '--------------------'
|          |                 |            |        Pod        |               ^
|          |                 v         .->|-------------------|--.            |
|          |     .-------------------. |  | sxapi-example-run |  |  .-------------------.
|          |     |   Deploy config   | |  '-------------------'  |  |      Service      |
|          |---->|-------------------|-'                         '->|-------------------|
|          |     | sxapi-example-run | |  .-------------------.  |  | sxapi-example-run |
|          |     '-------------------' |  |        Pod        |  |  '-------------------'
|          |                           '->|-------------------|--'
|          |                              | sxapi-example-run |
'----------'                              '-------------------'
```

## SXAPI Documentation

If you want to have more information on how to install, develop and run sxapi, please read the [full documentation](https://sxapi-core.readthedocs.io) or our [user guides](https://sxapi-core.readthedocs.io/guides) and execute the following steps :

1. [Install sxapi framework](https://sxapi-core.readthedocs.io/guides/1.Install.md)
2. [Configure you API](https://sxapi-core.readthedocs.io/guides/2.Configure.md)
3. [Run you application](https://sxapi-core.readthedocs.io/guides/3.Run.md)

## Troubleshooting

If you run into difficulties installing or running sxapi, you can [create an issue](https://github.com/startxfr/sxapi-core/issues/new).

## Built With

- [docker](https://www.docker.com) - Container plateform
- [alpine](https://alpinelinux.org) - OS envelop
- [nodejs](https://nodejs.org) - Application server
- [express](http://expressjs.com) - Web framework
- [sxapi](https://github.com/startxfr/sxapi-core) - Micro-service framework

## Contributing

Read the [contributing guide](https://sxapi-core.readthedocs.io/guides/5.Contribute) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

This project is mainly developped by the [startx](https://www.startx.fr) dev team. You can see the complete list of contributors who participated in this project by reading [CONTRIBUTORS.md](https://sxapi-core.readthedocs.io/CONTRIBUTORS).

## License

This project is licensed under the GPL Version 3 - see the [LICENSE.md](LICENSE) file for details
