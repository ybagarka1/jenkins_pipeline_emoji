node('master')
{
    stage('checkout')
    {
    git 'https://github.com/ahfarmer/emoji-search.git'
    }
    stage('build')
    {
        sh 'docker build -t $JOB_NAME:${JOB_NAME}_v_${BUILD_NUMBER} .'
    }
    stage('static code analysis')
    {
	# to be replaced with the actual code for analysis e.g. sonar
        sh 'echo execute static code analysis'
    }
    stage('push to repository manager')
    {
	# to be replaced with the actual commands to push to the docker registry
        sh 'echo uploading the image to artifactory/nexus'
    }
    stage('deploying to the remote server')
    {
        sh '''
                docker_container_id_emoji=`docker ps | grep emoji | cut -d " " -f1`
                if [[ -z $docker_container_id_emoji ]]
                then
		    # images are stored locally once the registry is set. docker image should be pulled first
                    docker run -p 80:3000 -d $JOB_NAME:${JOB_NAME}_v_${BUILD_NUMBER}
                else
                    echo $docker_container_id_emoji
                    docker stop $docker_container_id_emoji
                    docker rm $docker_container_id_emoji
                    docker run -p 80:3000 -d $JOB_NAME:${JOB_NAME}_v_${BUILD_NUMBER}
                fi
        '''
    }
}
