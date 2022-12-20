keys()
{
    INPUT_DICT=("$@")
    echo "main dist: ${INPUT_DICT[@]}"
    KEYS=()
    for DATA in "${INPUT_DICT[@]}" ; do
	echo $DATA
	echo "Before: ${KEYS[@]}"
        KEYS+=("${DATA%%:*}")
	echo "After: ${KEYS[@]}"
    done
    echo "${KEYS[@]}"
}

values()
{
    INPUT_DICT=("$@")
    VALUES=()
    for DATA in "${INPUT_DICT[@]}" ; do
        VALUES+=("${DATA##*:}")
    done
    echo "${VALUES[@]}"
}

pprint_dict()
{
    INPUT_DICT=("$@")
    for DATA in "${INPUT_DICT[@]}" ; do
        echo "${DATA%%:*}:${DATA##*:}"
    done
}


MAP=( "first:amol"
      "last:kokje"
    )

echo "KEYS=$(keys "${MAP[@]}")"
echo "VALUES=$(values "${MAP[@]}")"
pprint_dict "${MAP[@]}"
