FROM startx/sxapi:0.3.66

ENV SX_ID="startx/sxapi-example" \
    SX_NAME="Startx SXAPI Example" \
    SX_SUMMARY="Example instance of the SXAPI (small an eXtensible API) framework with a bunch of micro-services endpoints." \
    DESCRIPTION="SXAPI $SXAPI_VERSION Example instance with a bunch of micro-services endpoints." \
    SX_DEBUG=false

LABEL name="startx/sxapi-$SXAPI_VERSION-example" \
      summary="$SX_SUMMARY" \
      description="$DESCRIPTION." \
      maintainer="Startx <dev@startx.fr>" \
      help="For more information visit https://github.com/startxfr/sxapi-example" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="$SX_NAME" \
      io.openshift.tags="startx,nodejs,sxapi,sxapi-$SXAPI_VERSION,demo,example" \
      fr.startx.component="$SX_ID:$SXAPI_VERSION"

USER root

COPY ./mylib.js $APP_PATH/mylib.js
COPY ./sxapi.yaml $CONF_PATH/sxapi.yaml

RUN  chgrp -R 0 $APP_PATH &&  \
     chmod -R g=u $APP_PATH

USER 1001

EXPOSE 8077

CMD [ "npm" , "start" ]
