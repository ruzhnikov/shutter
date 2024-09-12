# RUNNING TESTS

## INSTALL DEPENDENCIES

```bash
# install cpanm
cpan App::cpanminus

# install dependencies from cpanfile
cpanm -v --installdeps .
```

## RUN TESTS

```bash
TEST_APP_SHUTTER_PATH=$(pwd) prove -I share/shutter/resources/modules/ -I t/lib t -r
```
