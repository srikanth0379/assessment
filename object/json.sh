json="{\"x1\": {\"y1\": {\"z1\": \"a1\"}}}"

value() {
  echo "Given object is ${1}"
  echo "Given Key is ${2}"
  value=`echo ${1} | jq .${2}`
  echo -e "value is \n ${value}"
}

value "$json" "x1.y1"
