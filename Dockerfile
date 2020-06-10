FROM startx/sxapi:0.3.49
MAINTAINER STARTX "dev@startx.fr"

USER root

COPY ./mylib.js $APP_PATH/mylib.js
COPY ./sxapi.yaml $CONF_PATH/sxapi.yaml

RUN  chgrp -R 0 $APP_PATH &&  chmod -R g=u $APP_PATH

USER 1001

EXPOSE 8080

WORKDIR $APP_PATH

CMD [ "npm" , "start" ]
