FROM landovsky/ruby:latest


## alias musi byt v .bashrc
RUN echo '---' > ~/.gemrc \
 && echo 'gem: --no-document' >> ~/.gemrc \
 && echo "alias rspecx='xvfb-run -a bundle exec rspec'" > ~/.bashrc

ENV APPDIR /givit
RUN mkdir $APPDIR
WORKDIR $APPDIR

ENV BUNDLE_JOBS=2 \
    BUNDLE_PATH=/gems \
    # do GEM_PATHS se musí přidat cesta z gem_storu
    GEM_PATH=$GEM_PATH:/gems \
    PATH=$PATH:/gems/bin

ADD . .
