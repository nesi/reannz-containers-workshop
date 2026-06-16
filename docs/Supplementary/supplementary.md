# 1. Supplementary - Other Options for Building Containers









## Extra for those Interested


Other sections of the `def` file (optional): 

* `%arguments`: These are variables that are referred to during a build
* `%setup`: 
* `%files`
* `%environment`
* `%post`
* `%runscript`
* `%startscript`
* `%test`
* `%labels`
* `%help`























An example of a `def` file is shown below:

```def
Bootstrap: docker
From: ubuntu:{{ VERSION }}
Stage: build

%arguments
    VERSION=22.04

%setup
    touch /file1
    touch ${APPTAINER_ROOTFS}/file2

%files
    /file1
    /file1 /opt

%environment
    export LISTEN_PORT=54321
    export LC_ALL=C

%post
    apt-get update && apt-get install -y netcat
    NOW=`date`
    echo "export NOW=\"${NOW}\"" >> $APPTAINER_ENVIRONMENT

%runscript
    echo "Container was created $NOW"
    echo "Arguments received: $*"
    exec echo "$@"

%startscript
    nc -lp $LISTEN_PORT

%test
    grep -q NAME=\"Ubuntu\" /etc/os-release
    if [ $? -eq 0 ]; then
        echo "Container base is Ubuntu as expected."
    else
        echo "Container base is not Ubuntu."
        exit 1
    fi

%labels
    Author myuser@example.com
    Version v0.0.1

%help
    This is a demo container used to illustrate a def file that uses all
    supported sections.
```

Note that this is a very complete `def` file which makes it look overwhelming. In general, you do not need to include all these features. We show it here just so we can describe all the features you can include in a `def` file. 



