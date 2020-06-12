#!/bin/bash

# This script is used for cutting a new release candidate of micro and go-micro
# It will create a new release-X.X.X branch (if it doesn't exist) and then create a new 
# release and tag in github

if [ -z $GITHUB_PERSONAL_TOKEN ]; then 
    echo Missing GITHUB_PERSONAL_TOKEN env var
    exit 1
fi

if [ $# -lt 2 ]; then 
    echo "Missing args. Should provide release number and candidate. ./cut-release-candidate.sh <X.X.X> <X> e.g. ./cut-release-candidate.sh 2.9.0 1"
    exit 1
fi 

release=$1
candidate=$2
timestamp=$(date +%s)
tempdir=micro-$release-$timestamp

mkdir $TMPDIR$tempdir
cd $TMPDIR$tempdir


function cut_release_branch {
    pushd $1
    git branch -a | grep "remotes/origin/release-$2$"
    if [ $? -eq 0 ]; then
        echo "Release branch release-$2 for $1 already exists"
        popd
        return 
    fi
    git checkout develop 
    git checkout -b release-$2
    git push origin release-$2
    popd
}

function generate_post_data {
    branchname=release-$1
    tagname=v$1
    if [ $2 ]; then
        tagname=$tagname-rc$2
    fi
    
    relname=$1
    if [ $2 ]; then
        relname="$relname Release Candidate $2"
    fi

  cat <<EOF
{
  "tag_name": "$tagname",
  "target_commitish": "$branchname",
  "name": "$relname",
  "draft": false,
  "prerelease": true
}
EOF
}

function publish_draft_release {
    echo publish draft release $1 $2

    pushd $1
    
    repo_full_name=$(git config --get remote.origin.url)
    url=$repo_full_name
    re="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+).git$"

    if [[ $url =~ $re ]]; then
        protocol=${BASH_REMATCH[1]}
        separator=${BASH_REMATCH[2]}
        hostname=${BASH_REMATCH[3]}
        user=${BASH_REMATCH[4]}
        repo=${BASH_REMATCH[5]}
    fi

    curl -H "Authorization: token $GITHUB_PERSONAL_TOKEN" --data "$(generate_post_data $2 $3)" "https://api.github.com/repos/$user/$repo/releases?access_token=$GITHUB_PERSONAL_TOKEN"
    popd 
}

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

git clone git@github.com:micro/go-micro.git
git clone git@github.com:micro/micro.git


cut_release_branch go-micro $release
publish_draft_release go-micro $release $candidate

cut_release_branch micro $release
update_go_micro_version $release $candidate
publish_draft_release micro $release $candidate 
