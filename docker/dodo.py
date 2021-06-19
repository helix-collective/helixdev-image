from hx.dodo_helpers import *
from datetime import date

HOME = Path(os.environ['HOME'])
HERE = Path('.')
ROOT = Path('../..')

helixdevimagebuilt = MarkerFile(HERE/'build/.helixdevimagebuilt')
helixdevimagepushed = MarkerFile(HERE/'build/.helixdevimagepushed')

def task_docker_build_helixdev_image():
    context = DockerContext()
    context.file( HERE/'01-install-base.sh', '01-install-base.sh')
    context.file( HERE/'02-install-tools.sh', '02-install-tools.sh')
    image = DockerImage( 'helixdev', context)
    image.cmd( 'FROM ubuntu:18.04' )
    image.cmd( 'MAINTAINER Helix Team <support@helixta.com.au>' )
    image.cmd( 'COPY 01-install-base.sh /tmp/')
    image.cmd( 'RUN bash -x /tmp/01-install-base.sh && rm -r /tmp/*' )
    image.cmd( 'ENV SDKMAN_DIR=/usr/local/sdkman')
    image.cmd( 'COPY 02-install-tools.sh /tmp/')
    image.cmd( 'RUN bash -x /tmp/02-install-tools.sh && rm -r /tmp/*' )

    return {
        'doc' : 'build the helix docker image containing development tools',
        'actions': [
            image.action(),
            helixdevimagebuilt.action()
        ],
        'file_dep': context.file_dep(),
        'targets': [helixdevimagebuilt.path],
        'verbosity' : 2,
        'clean' : True
    }

def task_docker_push_helixdev_image():
    tag = str(date.today()) + "-devtest-2"
    return {
        'doc' : 'push the helix dev docker image containing development tools',
        'actions': [
            'docker tag helixdev:latest helixta/helixdev:{0}'.format(tag),
            'docker push helixta/helixdev:{0}'.format(tag),
        ],
        'file_dep': [helixdevimagebuilt.path],
        'targets': [helixdevimagepushed.path],
        'verbosity' : 2,
        'clean' : True
    }
