QUARKUS_VERSION=1.2.1

function quarkus-new() {
	mvn io.quarkus:quarkus-maven-plugin:$QUARKUS_VERSION.Final:create \
    -DprojectGroupId=$1 \
    -DprojectArtifactId=$2 \
    -Dextensions="kafka-streams,resteasy-jsonb"
}
