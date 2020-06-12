#!/bin/bash

# This script is used for cutting a new prod release of go-micro and micro.
# It requires some manual intervention to merge PRs but will create a new release and tag of both projects
# on github and also update go.mod for micro

thisDir=$(dirname $0)

token=$GITHUB_PERSONAL_TOKEN
if [ -z $token ]; then 
    echo "Missing GITHUB_PERSONAL_TOKEN env var"
    exit 1
fi

if [ $# -lt 1 ]; then 
    echo "Missing args. Should provide release number. ./cut-prod-release.sh <X.X.X> e.g. ./cut-prod-release.sh 2.9.0"
    exit 1
fi 

release=$1
timestamp=$(date +%s)
tempdir=micro-$release-$timestamp
mkdir $TMPDIR$tempdir
cd $TMPDIR$tempdir


# update go micro to new version, release and optional suffix
function update_go_micro_version {
    pushd micro
    git checkout release-$1

    vstr=v$1
    if [ $2 ]; then
        vstr=$vstr-rc$2
    fi
    echo "Updating go-micro version to $vstr"
    go mod edit -require github.com/micro/go-micro/v2@$vstr
    while true
    do
        # it will take a bit of time to be replicated in sum.golang.org
        go get github.com/micro/go-micro/v2@$vstr
        if [ $? -eq 0 ]; then 
            break
        fi
        echo "go-micro not in sum.golang.org yet, waiting..."
        sleep 60
    done
    git add -u
    git commit -m 'update go-micro'
    git push origin release-$1
    popd
}



function ask {
    echo $1 "[y/N]"
    read ans
    if [ $ans != 'y' ]; then 
        exit 1
    fi
}

ask "This script publishes a new prod release. Are you sure you wish to continue?"
ask "Have you merged the PR for go-micro release-$1 -> master?"

function generate_post_data {
    tagname=v$1
    
    if [ $2 ]; then
        relname="Release $tagname"
    fi

  cat <<EOF
{
  "tag_name": "$tagname",
  "target_commitish": "master",
  "name": "$tagname",
  "draft": false,
  "prerelease": false
}
EOF
}

function release_it {
    echo "Cutting new release for $1 $2"
    curl -H "Authorization: token $GITHUB_PERSONAL_TOKEN" --data "$(generate_post_data $2)" "https://api.github.com/repos/micro/$1/releases"
}

release_it go-micro $release

git clone git@github.com:micro/micro.git
update_go_micro_version $release
ask "You now need to go and merge the PR for micro release-$1 -> master. I'll wait. Have you done it?"

release_it micro $release

echo "Now that's all released you still have work to do. Remember to merge master back to the develop branch to catch any fixes that were made to the release branch only."
