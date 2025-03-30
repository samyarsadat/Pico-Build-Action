# Tag creation function
create_tag() {
    local name=$1
    local msg_file_path="./$name-msg.txt"

    if [ ! -f "$msg_file_path" ]; then
        echo "ERROR: The tag message file $msg_file_path does not exist."
        exit 1
    fi

    git tag -fsa $name -F $msg_file_path
}

printf "Updating v1 version tag...\n"
git push origin :refs/tags/v1
create_tag v1

printf "\nDone, pushing new tag...\n"
git push origin --tags