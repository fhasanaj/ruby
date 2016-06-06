#!/bin/bash

retcode=0

#------------ Start Functions --------------------------

#Gets called when the user doesn't provide any args
function HELP {
    echo "  GIT_USERNAME - Git username where you would like to push the newly generated gh-pages"
    echo "  VERSION      - Publish version"
    exit 1
}

#------------ End Functions ----------------------------

#Gets GIT_USERNAME and VERSION if present
while getopts ":GIT_USERNAME:VERSION" arg; do
    case "${arg}" in
        GIT_USERNAME)
            GIT_USERNAME=${OPTARG}
            usage
            ;;
        VERSION)
            VERSION=${OPTARG}
            usage
            ;;
    esac
done

if [ -z ${GIT_USERNAME} ]; then
    echo "A git username is required"
    HELP
    usage
fi

if [ -z ${VERSION} ]; then
    echo "A version must be provided"
    HELP
    usage
fi

# Pull the latest from develop
# git clone git@github.com:rosette-api/ruby.git .
#Copy the mounted content in /source to current WORKDIR
cp -r -n /source/. .

d=$(date +"%Y-%m-%d")

echo "------------ Updating lib/rosette_api.rb BINDING_VERSION to ${VERSION}"
sed -i "/BINDING_VERSION = '.*'/c\  BINDING_VERSION = '${VERSION}'" lib/rosette_api.rb
echo "------------ Updating  s.version in rosette_api.gemspec to ${VERSION}"
sed -i "/\<s.version\>/c\  s.version            = '${VERSION}'" rosette_api.gemspec
echo "------------ Updating  s.date in rosette_api.gemspec to ${d}"
sed -i "/\<s.date\>/c\  s.date = %q{$d}" rosette_api.gemspec

echo "------------ Publishing gem, version: ${VERSION}"
gem build rosette_api.gemspec
gem push rosette_api-*.gem
rm -f rosette_api-*.gem

# Push changes in develop and merge it with master
echo "Pushing changes to develop and merging it with master"
git commit -a -m "Version ${VERSION}" && git push -u origin develop && git checkout master && git merge develop && git push -u origin master

# Add release tag to master
git tag -a ${VERSION}

#Generate gh-pages and push them to git
if [ ! -z ${GIT_USERNAME} ] && [ ! -z ${VERSION} ]; then    
    git checkout develop
    cd lib
    rdoc -o /doc
    git checkout origin/gh-pages -b gh-pages
    cp -r /doc/. /ruby
    cd /ruby
    git add .
    git commit -a -m "publish ruby apidocs ${VERSION}"
    git push
fi

exit ${retcode}
