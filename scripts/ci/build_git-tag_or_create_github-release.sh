#!/usr/bin/env bash

#set -ex

# Check whether it has 'release-notes.md' or 'release-title.md' in the target directory '.github'.
has_auto_release_flag=$(ls .github | grep -E "release-auto-flag.txt")
if [ "$has_auto_release_flag" == "" ]; then
    echo "â ï¸ It should have *release-auto-flag.txt* in '.github' directory of your project in HitHub."
    exit 0
else
    auto_release_flag=$(cat .github/release-auto-flag.txt)
    if [ "$auto_release_flag" == false ]; then
        echo "ð¤ Auto-release flag is 'false' so it won't build git tag or create GitHub release."
        exit 0
    fi
fi

has_release_notes=$(ls .github | grep -E "release-notes.md")
has_release_title=$(ls .github | grep -E "release-title.md")
if [ "$has_release_notes" == "" ]; then
    echo "â It should have *release-notes.md* in '.github' directory of your project in HitHub."
    exit 1
fi
if [ "$has_release_title" == "" ]; then
    echo "â It should have *release-title.md* in '.github' directory of your project in HitHub."
    exit 1
fi


# # # # python-package or github-action-reusable-workflow
Input_Arg_Release_Type=$1
Input_Arg_Debug_Mode=$2

if [ "$Input_Arg_Release_Type" == "" ]; then
    echo "â The argument 'Input_Arg_Release_Type' (first argument) cannot be empty."
    exit 1
fi

if [ "$Input_Arg_Release_Type" == 'python-package' ]; then
    # # # # The name of Python package
    Input_Arg_Python_Pkg_Name=$3
    # # # # For development and troubleshooting
#    Input_Arg_Debug_Mode=$4
    Input_Arg_Software_Version_Format=$4
elif [ "$Input_Arg_Release_Type" == 'github-action-reusable-workflow' ]; then
    Input_Arg_Python_Pkg_Name=""
    Input_Arg_Software_Version_Format=""
#    Input_Arg_Debug_Mode=$2
else
    echo "â Currently, it only has 2 release type: 'python-package' or 'github-action-reusable-workflow'."
    exit 1
fi
if [ "$Input_Arg_Debug_Mode" == "" ]; then
    Input_Arg_Debug_Mode=true
fi


# # # # From the PEP440: Software version style rule
# # #
# # # The version setting 1: version format
# # Simple âmajor.minorâ versioning: (general-2)
# 0.1,   0.2,   0.3,   1.0,   1.1
# # Simple âmajor.minor.microâ versioning: (general-3)
# 1.0.0,   1.0.1,   1.0.2,   1.1.0
# # Date based releases, using an incrementing serial within each year, skipping zero: (date-based)
# 2012.1,   2012.2,  ...,   2012.15,   2013.1,   2013.2
# # # The version setting 2: version evolution
# # âmajor.minorâ versioning with alpha, beta and candidate pre-releases: (sema)
# 0.9,   1.0a1,   1.0a2,   1.0b1,   1.0rc1,   1.0
# # âmajor.minorâ versioning with developmental releases, release candidates and post-releases for minor corrections: (dev)
# 0.9,   1.0.dev1,   1.0.dev2,   1.0.dev3,   1.0c1,   1.0,   1.0.post1,   1.1.dev1
#Input_Arg_Software_Version_Format=$3

declare Software_Version_Reg
declare Python_Version_Reg

if [ "$Input_Arg_Release_Type" == 'python-package' ]; then

    if [ "$Input_Arg_Python_Pkg_Name" == "" ]; then
        echo "â The argument 'Input_Arg_Python_Pkg_Name' (second argument) cannot be empty if option 'Input_Arg_Release_Type' (first argument) is 'python-package'."
        exit 1
    fi

    declare version_reg
    if [ "$Input_Arg_Software_Version_Format" == "general-2" ]; then
        version_reg="[0-9]\.[0-9]"
    elif [ "$Input_Arg_Software_Version_Format" == "general-3" ]; then
        version_reg="[0-9]\.[0-9]\.[0-9]"
    elif [ "$Input_Arg_Software_Version_Format" == "date-based" ]; then
        version_reg="[0-9]{4}\.([0-9]{1,})+"
    else
        # Default value
        version_reg="[0-9]\.[0-9]\.[0-9]"
    fi

    Software_Version_Reg="$version_reg*([\.,-]*([a-zA-Z]{1,})*([0-9]{0,})*){0,}"
    Python_Version_Reg="__version__ = \"$Software_Version_Reg\""

fi

#if [ "$Input_Arg_Release_Type" == 'python-package' ]; then
#    if [ "$software_version_evolution" == "sema" ]; then
#        echo "*-*([a-zA-Z]{1,})*([0-9]{0,})"
#    elif [ "$software_version_evolution" == "dev" ]; then
#        echo "*[\.,-]*([a-zA-Z]{1,})*([0-9]{0,})"
#    else
#        # Default value
#        echo ""
#    fi
#fi


#Current_Branch=$(git branch --show-current)
# # # # For debug
#echo "Verify the git branch info"
#git branch --list | cat
#echo "Verify all the git branch info"
#git branch -a | cat
#echo "Verify the git remote info"
#git remote -v
#echo "Get the current git branch info"

# This is the global value to provide after-handle to use
Current_Branch=$(git branch --list | cat | grep -E '\* ([a-zA-Z0-9]{1,16})' | grep -E -o '([a-zA-Z0-9]{1,16})')
echo "ð ð³  Current git branch: $Current_Branch"

git config --global user.name "Chisanan232"
git config --global user.email "chi10211201@cycu.org.tw"
git_global_username=$(git config --global user.name)
git_global_user_email=$(git config --global user.email)
echo "ð ð³  Current git name: $git_global_username"
echo "ð ð³  Current git email: $git_global_user_email"

git pull
echo "ð© ð³  git pull done"

declare Tag_Version    # This is the return value of function 'get_latest_version_by_git_tag'
get_latest_version_by_git_tag() {
    # # # # The types to get version by tag: 'git' or 'github'
    get_version_type=$1

    if [ "$get_version_type" == "git" ]; then
        echo "ð ð³ ð· Get the version info from git tag."
        Tag_Version=$(git describe --tag --abbrev=0 --match "v[0-9]\.[0-9]\.[0-9]*" | grep -E -o '[0-9]\.[0-9]\.[0-9]*')
    elif [ "$get_version_type" == "github" ]; then
        echo "ð ð ð ð·  Get the version info from GitHub release."
        github_release=$(curl -s https://api.github.com/repos/Chisanan232/GitHub-Action_Reusable_Workflows-Python/releases/latest | jq -r '.tag_name')
        Tag_Version=$(echo "$github_release" | grep -E -o '[0-9]\.[0-9]\.[0-9]*')
    else
        echo "â Currently, it only has 2 valid options could use: 'git' or 'github'."
        exit 1
    fi
}


declare New_Release_Version    # This is the return value of function 'generate_new_version_as_tag'
declare New_Release_Tag    # This is the return value of function 'generate_new_version_as_tag'
generate_new_version_as_tag() {
    project_type=$1
    if [ "$project_type" == "python" ]; then
        echo "ð ð ð¦  Get the new version info from Python package."
        New_Release_Version=$(cat ./"$Input_Arg_Python_Pkg_Name"/__pkg_info__.py | grep -E "$Python_Version_Reg" | grep -E -o "$Software_Version_Reg")
    elif [ "$project_type" == "github-action_reusable-workflow" ]; then
        echo "ð ð ð ð·  Get the current version info from GitHub release."
        # Generate the new version from previous tag
        get_latest_version_by_git_tag 'github'
        current_ver=$(echo "$Tag_Version" | head -n1 | cut -d "." -f1)
        echo "ð ð  Current Version: $current_ver"

#        current_ver=$(git describe --tag --abbrev=0 --match "v[0-9]\.[0-9]\.[0-9]" | grep -E -o '[0-9]\.[0-9]\.[0-9]' | head -n1 | cut -d "." -f1)
        if [ "$current_ver" == "" ]; then
            current_ver=0
        fi
        New_Release_Version=$(( current_ver + 1 ))
    fi

    New_Release_Tag='v'$New_Release_Version'.0.0'
}


build_git_tag_or_github_release() {
    # git event: push
    # all branch -> Build tag
    # master branch -> Build tag and create release

    project_type=$1
    generate_new_version_as_tag "$project_type"

    if [ "$Input_Arg_Debug_Mode" == true ]; then
        echo " ðð [DEBUG MODE] Build git tag $New_Release_Tag in git branch '$Current_Branch'."
    else
        git tag -a "$New_Release_Tag" -m "$New_Release_Tag"
        git push -u origin --tags
    fi
    echo "ð ð» ð³ ð·  Build git tag which named '$New_Release_Tag' with current branch '$Current_Branch' successfully!"

    if [ "$Current_Branch" == "master" ]; then
        release_title=$(cat .github/release-title.md)

        if [ "$Input_Arg_Debug_Mode" == true ]; then
            echo " ðð [DEBUG MODE] Create GitHub release with tag '$New_Release_Tag' and title '$release_title' in git branch '$Current_Branch'."
        else
            gh release create "$New_Release_Tag" --title "$release_title" --notes-file .github/release-notes.md
        fi
    fi
        echo "ð ð» ð ð ð·  Create GitHub release with title '$release_title' successfully!"
}


# The truly running implementation of shell script
if [ "$Input_Arg_Release_Type" == 'python-package' ]; then

    # # # # For Python package release
    echo "ðââ ï¸ð ð Run python package releasing process"

    git_tag=$(git describe --tag --abbrev=0 --match "v[0-9]\.[0-9]\.[0-9]*" | grep -o '[0-9]\.[0-9]\.[0-9]*')
    github_release=$(curl -s https://api.github.com/repos/Chisanan232/GitHub-Action_Reusable_Workflows-Python/releases/latest | jq -r '.tag_name')
    # shellcheck disable=SC2002
    generate_new_version_as_tag "python"

    build_git_tag=false
    create_github_release=false

    # 1. Compare the Python source code version and git tag, GitHub release version.
    if [ "$New_Release_Version" == "$git_tag" ]; then
        echo "â  Version of git tag info are the same. So it verifies it has built and pushed before."
    else
        echo "â ï¸  Version of git tag info are different. So it verifies it doesn't build and push before."
        build_git_tag=true
    fi

    if [ "$Current_Branch" == "master" ] && [ "$New_Release_Version" == "$github_release" ]; then
        echo "â  Version of GitHub release info are the same. So it verifies it has built and pushed before."
    else
        echo "â ï¸  Version of GitHub release info are different. So it verifies it doesn't build and push before."
        create_github_release=true
    fi

    # 1. -> Same -> 1-1. Does it have built and pushed before?.
    # 1. -> No (In generally, it should no) -> 1-2. Is it a pre-release version in source code?

    # 1-1. Yes, it has built and pushed. -> Doesn't do anything.
    # 1-1. No, it doesn't build and push before. -> Build and push directly.

    # 1-2. Yes, it's pre-release. -> Doesn't build and push. Just build git tag and GitHub release.
    # 1-2. No, it's not pre-release. -> It means that it's official version, e.g., 1.3.2 version. So it should build git tag and GitHub release first, and build and push.

    if [ "$build_git_tag" == true ] || [ "$create_github_release" == true ]; then

        echo "ð ð ð¦ Python package new release version: $New_Release_Version"
        is_pre_release_version=$(echo $New_Release_Version | grep -E -o '([\.-]*([a-zA-Z]{1,})+([0-9]{0,})*){1,}')
        echo "ð ð¤° ð¦ is pre-release version: $is_pre_release_version"
        if [ "$is_pre_release_version" == "" ]; then
            echo "ð ð ð¦ The version is a official-release."
            # do different things with different ranches
            # git event: push
            # all branch -> Build tag
            # master branch -> Build tag and create release
            echo "ð·ð½ââï¸ ð Build tag and create GitHub release, also push code to PyPi"
            build_git_tag_or_github_release "python"
            echo "â ð ð¥ Done! This is Official-Release so please push source code to PyPi."
            echo "[Python] [Final Running Result] Official-Release"
        else
            echo "The version is a pre-release."
            # do different things with different ranches
            # git event: push
            # all branch -> Build tag
            # master branch -> Build tag and create release
            echo "ð·ð½ââ ï¸ð Build tag and create GitHub release only"
            build_git_tag_or_github_release "python"
            echo "â ð ð¥ Done! This is Pre-Release so please don't push this to PyPi."
            echo "[Python] [Final Running Result] Pre-Release"
        fi

    fi

elif [ "$Input_Arg_Release_Type" == 'github-action-reusable-workflow' ]; then

    echo "ðââ  ð ð ð  Run github-action-reusable-workflow releasing process"
    # # # # For GitHub Action reusable workflow template release
    # 1. Compare whether the release-notes.md has different or not.
    # Note 1: Diff a specific file with currently latest tag and previous one commit
    # https://stackoverflow.com/questions/3338126/how-do-i-diff-the-same-file-between-two-different-commits-on-the-same-branch
    # Note 2: Show the output result in stdout directly
    # https://stackoverflow.com/questions/17077973/how-to-make-git-diff-write-to-stdout
    # Note 3: Here code should be considered what git tag on master branch so we need to verify the info on master branch.
    # Note 4: We should git fetch to provide git diff feature working
    # https://github.com/actions/checkout/issues/160

    echo "ð³ â ð³ Run git fetch to sync upstream with latest project in GitHub"
    git fetch --no-tags --prune --depth=1 origin +refs/heads/*:refs/remotes/origin/*

    echo "ð ð³ ð³ Verify all the git branch info again after git fetch."
    git branch -a | cat

    echo "ð ð ð³ Verify the git remote info again after git fetch."
    git remote -v

    echo "ð¬ ð ð³ â ð³ Check the different of '.github/release-notes.md' between current git branch and master branch ..."
    # # v1: compare by git branches
#    release_notes_has_diff=$(git diff origin/master "$Current_Branch" -- .github/release-notes.md | cat)
    # # v2: compare by git tag
    all_git_tags=$(git tag -l | cat)
    declare -a all_git_tags_array=( $(echo "$all_git_tags" | awk -v RS='' '{gsub("\n","  "); print}') )
    all_git_tags_array_len=${#all_git_tags_array[@]}
    latest_git_tag=${all_git_tags_array[$all_git_tags_array_len - 1]}
    echo "ð ð³ ð· The latest git tag: $latest_git_tag"

    release_notes_has_diff=$(git diff "$latest_git_tag" "$Current_Branch" -- .github/release-notes.md | cat)
    echo "ð ð¬ ð different of '.github/release-notes.md': $release_notes_has_diff"

    if [ "$release_notes_has_diff" != "" ]; then
        # 1. Yes, it has different. -> Build git tag, GitHub release and version branch
        build_git_tag_or_github_release "github-action_reusable-workflow"
        echo "â ð ð¥ Done! This is Official-Release of GitHub Action reusable workflow, please create a version branch of it."
        echo "[GitHub Action - Reusable workflow] [Final Running Result] Official-Release and version: $New_Release_Version"
    else
        # 1. No, do nothing.
        # Return nothing output
        echo "ð¤ Release note file doesn't change. Don't do anything."
        echo "[GitHub Action - Reusable workflow] [Final Running Result] Pre-Release"
    fi

fi
