
# Nzyme update Java from v15 to v17 in its 2.0.0-alpha.15 release
# So this function is called in the dependencies var of both nzyme node and tap to determine what version of java to install
function "determine-jdk-version" {
  params = [version]
  result = version > 14 ? 17 : 15
}

# NOTE: Do not add add '/' to the end of both REG_HOST and REG_PROJECT
variable REG_HOST {
    default = ""
}

variable REG_PROJECT {
    default = ""
}

variable NZYME_NODE_DOCKER_IMAGE_NAME { 
    default = "nzyme-node"
}


variable NZYME_TAP_DOCKER_IMAGE_NAME { 
    default = "nzyme-tap"
}

variable VERSION {
    default = 17
}

variable TAG {
  default = "v2a${VERSION}"
}

target "_base" {
    platforms  = ["linux/amd64"]
    contexts = {
        base_image = "docker-image://ubuntu:24.04"
    }
    args = {
        NZYME_USER_ID = 1001
    }
}

target "nzyme_node_v2_common" {
    inherits = ["_base"]
    context = "build/v2/node"
    dockerfile = "Dockerfile"
    args = {
        DOWNLOAD_TARGET = "https://github.com/nzymedefense/nzyme/releases/download/2.0.0-alpha.${VERSION}/nzyme-node_ubuntu-2404noble-noarch-2.0.0-alpha.${VERSION}.deb"
        DEPENDENCIES = "openjdk-${determine-jdk-version(VERSION)}-jre-headless gettext postgresql-client gettext"
    }
}

target "nzyme_node_v2" {
    inherits = ["nzyme_node_v2_common"]
    target = "nzyme-node"
    args = {
        PORT = 22900
    }
    tags = ["${REG_HOST}${REG_PROJECT}${NZYME_NODE_DOCKER_IMAGE_NAME}:${TAG}"]
}

target "nzyme_node_migration_v2" {
    inherits = ["nzyme_node_v2_common"]
    target = "nzyme-node-migration"
    tags = ["${REG_HOST}${REG_PROJECT}${NZYME_NODE_DOCKER_IMAGE_NAME}-migration:${TAG}"]
}

target "nzyme_tap_v2" {
    inherits = ["_base"]
    context = "build/v2/tap"
    dockerfile = "Dockerfile"
    args = {       
        DOWNLOAD_TARGET = "https://github.com/nzymedefense/nzyme/releases/download/2.0.0-alpha.${VERSION}/nzyme-tap_ubuntu-2404noble-amd64-2.0.0-alpha.${VERSION}.deb"
        DEPENDENCIES = "openjdk-${determine-jdk-version(VERSION)}-jre-headless libpcap0.8 libpcap0.8t64 gettext iw"
    }
    tags = ["${REG_HOST}${REG_PROJECT}${NZYME_TAP_DOCKER_IMAGE_NAME}:${TAG}"]
}
