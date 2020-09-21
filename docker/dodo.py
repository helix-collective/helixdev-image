from hx.dodo_helpers import *
from datetime import date

HOME = Path(os.environ['HOME'])
HERE = Path('.')
ROOT = Path('../..')

helixdevimagebuilt = MarkerFile(HERE/'build/.helixdevimagebuilt')
helixdevimagepushed = MarkerFile(HERE/'build/.helixdevimagepushed')

def task_docker_build_helixdev_image():
    context = DockerContext()
    context.file( HERE/'install.helixdev.sh', 'install.sh')
    image = DockerImage( 'helixdev', context)
    image.cmd( 'FROM ubuntu:18.04' )
    image.cmd( 'MAINTAINER Helix Team <support@helixta.com.au>' )
    image.cmd( 'COPY install.sh /tmp/')
    image.cmd( 'RUN sh -x /tmp/install.sh && rm -r /tmp/*' )

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
    tag = str(date.today())
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
