# Build
custom_build(
    # Name of the container Image
    ref = 'config-service',
    # Command to build container Image
    command = './gradlew bootBuildImage --imageName $EXPECTED_REF',
    # Files to watch that triggers a new build
    deps = ['build.gradle', 'src'],
    disable_push=True
)

local_resource(
    name='Load config-service into minikube',
    cmd='minikube image load config-service --profile polar',
)

# Deploy
k8s_yaml(['k8s/deployment.yml', 'k8s/service.yml'])