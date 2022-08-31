#!/usr/bin/env bash

#set -ex

# Check whether it has 'release-notes.md' or 'release-title.md' in the target directory '.github'.
has_auto_release_flag=$(ls .github | grep -E "release-auto-flag.txt")
if [ "$has_auto_release_flag" == "" ]; then
    echo "It should have *release-auto-flag.txt* in '.github' directory of your project in HitHub."
    exit 0
else
    auto_release_flag=$(cat .github/release-auto-flag.txt)
    if [ "$auto_release_flag" == false ]; then
        echo "Auto-release flag is 'false' so it won't build git tag or create GitHub release."
        exit 0
    fi
fi

has_release_notes=$(ls .github | grep -E "release-notes.md")
has_release_title=$(ls .github | grep -E "release-title.md")
if [ "$has_release_notes" == "" ]; then
    echo "It should have *release-notes.md* in '.github' directory of your project in HitHub."
    exit 1
fi
if [ "$has_release_title" == "" ]; then
    echo "It should have *release-title.md* in '.github' directory of your project in HitHub."
    exit 1
fi


# # # # python-package or github-action-reusable-workflow
Input_Arg_Release_Type=$1
Input_Arg_Debug_Mode=$2

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
    echo "Currently, it only has 2 release type: 'python-package' or 'github-action-reusable-workflow'."
    exit 1
fi
if [ "$Input_Arg_Debug_Mode" == "" ]; then
    Input_Arg_Debug_Mode=true
fi

if [ "$Input_Arg_Release_Type" == "" ]; then
    echo "The argument 'Input_Arg_Release_Type' (first argument) cannot be empty."
    exit 1
fi


# # # # From the PEP440: Software version style rule
# # #
# # # The version setting 1: version format
# # Simple “major.minor” versioning: (general-2)
# 0.1,   0.2,   0.3,   1.0,   1.1
# # Simple “major.minor.micro” versioning: (general-3)
# 1.0.0,   1.0.1,   1.0.2,   1.1.0
# # Date based releases, using an incrementing serial within each year, skipping zero: (date-based)
# 2012.1,   2012.2,  ...,   2012.15,   2013.1,   2013.2
# # # The version setting 2: version evolution
# # “major.minor” versioning with alpha, beta and candidate pre-releases: (sema)
# 0.9,   1.0a1,   1.0a2,   1.0b1,   1.0rc1,   1.0
# # “major.minor” versioning with developmental releases, release candidates and post-releases for minor corrections: (dev)
# 0.9,   1.0.dev1,   1.0.dev2,   1.0.dev3,   1.0c1,   1.0,   1.0.post1,   1.1.dev1
#Input_Arg_Software_Version_Format=$3

declare Software_Version_Reg
declare Python_Version_Reg

if [ "$Input_Arg_Release_Type" == 'python-package' ]; then

    if [ "$Input_Arg_Python_Pkg_Name" == "" ]; then
        echo "The argument 'Input_Arg_Python_Pkg_Name' (second argument) cannot be empty if option 'Input_Arg_Release_Type' (first argument) is 'python-package'."
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
echo "Current git branch: $Current_Branch"


declare Tag_Version    # This is the return value of function 'get_latest_version_by_git_tag'
get_latest_version_by_git_tag() {
    # # # # The types to get version by tag: 'git' or 'github'
    get_version_type=$1

    if [ "$get_version_type" == "git" ]; then
        echo ""
        Tag_Version=$(git describe --tag --abbrev=0 --match "v[0-9]\.[0-9]\.[0-9]*" | grep -E -o '[0-9]\.[0-9]\.[0-9]*')
    elif [ "$get_version_type" == "github" ]; then
        echo ""
        github_release=$(curl -s https://api.github.com/repos/Chisanan232/GitHub-Action_Workflow-Template-Python/releases/latest | jq -r '.tag_name')
        Tag_Version=$(echo "$github_release" | grep -E -o '[0-9]\.[0-9]\.[0-9]*')
    else
        echo ""
        exit 1
    fi
}


declare New_Release_Version    # This is the return value of function 'generate_new_version_as_tag'
declare New_Release_Tag    # This is the return value of function 'generate_new_version_as_tag'
generate_new_version_as_tag() {
    project_type=$1
    if [ "$project_type" == "python" ]; then
        echo ""
        New_Release_Version=$(cat ./"$Input_Arg_Python_Pkg_Name"/__pkg_info__.py | grep -E "$Python_Version_Reg" | grep -E -o "$Software_Version_Reg")
    elif [ "$project_type" == "github-action_reusable-workflow" ]; then
        echo ""
        # Generate the new version from previous tag
        get_latest_version_by_git_tag 'github'
        current_ver=$(echo "$Tag_Version" | head -n1 | cut -d "." -f1)
        echo "current_ver: $current_ver"

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
        echo " 🔍👀[DEBUG MODE] Build git tag $New_Release_Tag in git branch '$Current_Branch'."
    else
        git tag -a "$New_Release_Tag" -m "$New_Release_Tag"
        git push -u origin --tags
    fi

    echo "Build git tag which named '$New_Release_Tag' with current branch '$Current_Branch' successfully!"
    if [ "$Current_Branch" == "master" ]; then
        release_title=$(cat .github/release-title.md)

        if [ "$Input_Arg_Debug_Mode" == true ]; then
            echo " 🔍👀[DEBUG MODE] Create GitHub release with tag '$New_Release_Tag' and title '$release_title' in git branch '$Current_Branch'."
        else
            gh release create "$New_Release_Tag" --title "$release_title" --notes-file .github/release-notes.md
        fi

        echo "Create GitHub release with title '$release_title' successfully!"
    fi
}


# The truly running implementation of shell script
if [ "$Input_Arg_Release_Type" == 'python-package' ]; then

    # # # # For Python package release
    echo 'do python package release'

    git_tag=$(git describe --tag --abbrev=0 --match "v[0-9]\.[0-9]\.[0-9]*" | grep -o '[0-9]\.[0-9]\.[0-9]*')
    github_release=$(curl -s https://api.github.com/repos/Chisanan232/GitHub-Action_Workflow-Template-Python/releases/latest | jq -r '.tag_name')
    # shellcheck disable=SC2002
    pkg_version=$(cat ./"$Input_Arg_Python_Pkg_Name"/__pkg_info__.py | grep -E "$Python_Version_Reg" | grep -E -o "$Software_Version_Reg")

    build_git_tag=false
    create_github_release=false

    # 1. Compare the Python source code version and git tag, GitHub release version.
    if [ "$pkg_version" == "$git_tag" ]; then
        echo "Version of git tag info are the same. So it verifies it has built and pushed before."
    else
        echo "Version of git tag info are different. So it verifies it doesn't build and push before."
        build_git_tag=true
    fi

    if [ "$Current_Branch" == "master" ] && [ "$pkg_version" == "$github_release" ]; then
        echo "Version of GitHub release info are the same. So it verifies it has built and pushed before."
    else
        echo "Version of GitHub release info are different. So it verifies it doesn't build and push before."
        create_github_release=true
    fi

    # 1. -> Same -> 1-1. Does it have built and pushed before?.
    # 1. -> No (In generally, it should no) -> 1-2. Is it a pre-release version in source code?

    # 1-1. Yes, it has built and pushed. -> Doesn't do anything.
    # 1-1. No, it doesn't build and push before. -> Build and push directly.

    # 1-2. Yes, it's pre-release. -> Doesn't build and push. Just build git tag and GitHub release.
    # 1-2. No, it's not pre-release. -> It means that it's official version, e.g., 1.3.2 version. So it should build git tag and GitHub release first, and build and push.

    if [ "$build_git_tag" == true ] || [ "$create_github_release" == true ]; then

        echo "pkg_version: $pkg_version"
#        is_pre_release_version=$(echo $pkg_version | sed -n 's/.*\([a-zA-Z][0-9]*\)/\1/p')
        is_pre_release_version=$(echo $pkg_version | grep -E -o '([\.-]*([a-zA-Z]{1,})+([0-9]{0,})*){1,}')
        echo "is_pre_release_version: $is_pre_release_version"
        if [ "$is_pre_release_version" == "" ]; then
            echo "The version is not a pre-release."
            # do different things with different ranches
            # git event: push
            # all branch -> Build tag
            # master branch -> Build tag and create release
            echo "build tag and create GitHub release, also push code to PyPi"
            build_git_tag_or_github_release "python"
            echo "Done! This is Official-Release so please push source code to PyPi."
            echo "[Python] [Final Running Result] Official-Release"
        else
            echo "The version is a pre-release."
            # do different things with different ranches
            # git event: push
            # all branch -> Build tag
            # master branch -> Build tag and create release
            echo "build tag and create GitHub release only"
            build_git_tag_or_github_release "python"
            echo "Done! This is Pre-Release so please don't push this to PyPi."
            echo "[Python] [Final Running Result] Pre-Release"
        fi

    fi

elif [ "$Input_Arg_Release_Type" == 'github-action-reusable-workflow' ]; then

    echo 'do github-action-reusable-workflow release'
    # # # # For GitHub Action reusable workflow template release
    # 1. Compare whether the release-notes.md has different or not.
    # Note 1: Diff a specific file with currently latest tag and previous one commit
    # https://stackoverflow.com/questions/3338126/how-do-i-diff-the-same-file-between-two-different-commits-on-the-same-branch
    # Note 2: Show the output result in stdout directly
    # https://stackoverflow.com/questions/17077973/how-to-make-git-diff-write-to-stdout
    # Note 3: Here code should be considered what git tag on master branch so we need to verify the info on master branch.
    # Note 4: We should git fetch to provide git diff feature working
    # https://github.com/actions/checkout/issues/160

    echo "Run git fetch to sync upstream with latest project in GitHub"
    git fetch --no-tags --prune --depth=1 origin +refs/heads/*:refs/remotes/origin/*

    echo "Verify all the git branch info again after git fetch."
    git branch -a | cat

    echo "Verify the git remote info again after git fetch."
    git remote -v

    echo "Check the different between current git branch and master branch."
    release_notes_has_diff=$(git diff origin/master "$Current_Branch" -- .github/release-notes.md | cat)
    echo "release_notes_has_diff: $release_notes_has_diff"

    if [ "$release_notes_has_diff" != "" ]; then
        # 1. Yes, it has different. -> Build git tag, GitHub release and version branch
        build_git_tag_or_github_release "github-action_reusable-workflow"
        echo "Done! This is Official-Release of GitHub Action reusable workflow, please create a version branch of it."
        echo "[GitHub Action - Reusable workflow] [Final Running Result] Official-Release and version: $New_Release_Version"
    else
        # 1. No, do nothing.
        # Return nothing output
        echo "Release note file doesn't change. Don't do anything."
        echo "[GitHub Action - Reusable workflow] [Final Running Result] Pre-Release"
    fi

fi