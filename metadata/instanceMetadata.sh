#!/bin/bash

apiVersion() {
	curl -s -H Metadata:true "http://169.254.169.254/metadata/versions" | jq .apiVersions[-1] | sed "s/\"//g"
}

instanceMetadata() {
        api=`apiVersion`
	curl -s -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=${api}" | jq .
}

instanceMetadata
