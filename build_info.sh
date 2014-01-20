#!/bin/sh

build_time=$(date +%s)

git_branch=$(git symbolic-ref --short -q HEAD)
git_tag=$(git describe --tags --exact-match 2>/dev/null)
git_commit_count=$(git rev-list HEAD --count)
git_hash=$(git rev-parse --short HEAD)

info_plist="${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '${git_commit_count}'" "${info_plist}"
/usr/libexec/PlistBuddy -c "Set :KKBuildTimeStamp '${build_time}'" "${info_plist}"
/usr/libexec/PlistBuddy -c "Set :KKGitBranch '${git_branch}'" "${info_plist}"
/usr/libexec/PlistBuddy -c "Set :KKGitTag '${git_tag}'" "${info_plist}"
/usr/libexec/PlistBuddy -c "Set :KKGitCommitCount '${git_commit_count}'" "${info_plist}"
/usr/libexec/PlistBuddy -c "Set :KKGitHash '${git_hash}'" "${info_plist}"
