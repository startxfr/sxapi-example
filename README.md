# sxapi-example

Example of a micro-service application using startx sxapi s2i builder [startx/sxapi](https://hub.docker.com/r/startx/sxapi) (using [source-to-image](https://github.com/openshift/source-to-image)).
See [using sxapi builder](https://github.com/startxfr/sxapi-core/blob/master/docs/guides/USE_docker.md#using-openshift) to learn on how to build this example.

The easyest way to start building you own API resource is to fork this repository and start to personalize `sxapi.json`. 
Follow the [sxapi configuration guide](https://github.com/startxfr/sxapi-core/blob/master/docs/guides/2.Configure.md) to learn
how to create your own microservice endpoints winthin a minute.

## Running this example

### Running on openshift 

#### Requirements

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
- Create a project for this application
```bash
# <project_name> The project name
oc new-project <project_name>
```

#### Create application using the build template

```bash
oc process -f https://raw.githubusercontent.com/startxfr/sxapi-example/master/openshift-template-build.json \
   -p APP_NAME=sxapi1 \
   -p APP_TYPE=example \
   -p SOURCE_BRANCH=master \
   -p WEBHOOK_TOKEN=sxapi-example-e7h91Yka4p7qD24 | \
oc create -f -
```

#### Create application using the pipeline template

```bash
oc process -f https://raw.githubusercontent.com/startxfr/sxapi-example/master/openshift-template-pipeline.json \
   -p APP_NAME=sxapi2 \
   -p APP_TYPE=example \
   -p SOURCE_BRANCH=master \
   -p WEBHOOK_TOKEN=sxapi-example-f5H34pASlaiZ27c | \
oc create -f -
```

## SXAPI Documentation

If you want to have more information on how to install, develop and run sxapi, please read the [full documentation](https://github.com/startxfr/sxapi-core/tree/master/docs/README.md) or our [user guides](https://github.com/startxfr/sxapi-core/tree/master/docs/guides/README.md) and execute the following steps :
1. [Install sxapi framework](https://github.com/startxfr/sxapi-core/tree/master/docs/guides/1.Install.md)
2. [Configure you API](https://github.com/startxfr/sxapi-core/tree/master/docs/guides/2.Configure.md)
3. [Run you application](https://github.com/startxfr/sxapi-core/tree/master/docs/guides/3.Run.md)

## Troubleshooting

If you run into difficulties installing or running sxapi, you can [create an issue](https://github.com/startxfr/sxapi-core/issues/new).

## Built With

* [docker](https://www.docker.com/) - Container plateform
* [alpine](https://alpinelinux.org/) - OS envelop
* [nodejs](https://nodejs.org) - Application server
* [express](http://expressjs.com) - Web framework
* [sxapi](https://github.com/startxfr/sxapi-core) - Micro-service framework

## Contributing

Read the [contributing guide](https://github.com/startxfr/sxapi-core/tree/master/docs/guides/5.Contribute.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

This project is mainly developped by the [startx](https://www.startx.fr) dev team. You can see the complete list of contributors who participated in this project by reading [CONTRIBUTORS.md](https://github.com/startxfr/sxapi-core/tree/master/docs/CONTRIBUTORS.md).

## License

This project is licensed under the GPL Version 3 - see the [LICENSE.md](https://github.com/startxfr/sxapi-core/tree/master/docs/LICENSE.md) file for details
