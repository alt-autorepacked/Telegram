#!/bin/sh

epm tool eget https://raw.githubusercontent.com/alt-autorepacked/common/v0.3.0/common.sh
. ./common.sh
# . ../common/common.sh

_package="Telegram"


_download() {
    real_download_url=$(epm tool eget --get-real-url $url)
    epm -y pack $_package $real_download_url
}

url=$(epm tool eget --list https://github.com/telegramdesktop/tdesktop/releases/latest "tsetup.*.tar.xz" | grep -v beta | head -1)

download_version=$(echo $url | grep -oP $_version_grep | head -1)
remote_version=$(_check_version_from_remote)

if [ "$remote_version" != "$download_version" ]; then
    _download
    _add_repo_suffix
    TAG="v$download_version"
    _create_release
    echo "Release created: $TAG"
else
    echo "No new version to release. Current version: $download_version"
fi

rm common.sh