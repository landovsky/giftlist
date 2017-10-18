FROM rails:latest

ENV APPDIR /givit

RUN mkdir $APPDIR
WORKDIR $APPDIR

ENV BUNDLE_JOBS=2 \
    BUNDLE_PATH=/gems

ADD . .
