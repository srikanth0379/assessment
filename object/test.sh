declare -A John=( ["age"]="23" ["weight"]="150" )
declare -A Jackie=( ["age"]="21" ["weight"]="140" )
declare -a dict=("John" "Jackie")

for member in "${dict[@]}"; do
    echo "dist: ${dict[@]}"
    echo "$member :"
    declare -n p="$member"  # now p is a reference to a variable "$member"
    for attr in "${!p[@]}"; do
        echo "    $attr : ${p[$attr]}"
    done
done
