#!/bin/bash

start_program_cmd=$1
inputFolder=$2

inputList=$(ls ${inputFolder}/input*[0-9].txt)
outputList=($(ls ${inputFolder}/output*[0-9].txt))


getTime() {
    echo $(($(date +%s%N)/1000000))
}

setGreen() {
    echo -en "\e[32m"
}

setDefaultColor() {
    echo -en "\e[39m"
}

setRed() {
    echo -en "\e[31m"
}


TMP_OUTPUT_PATH="/tmp/coding_challenge_watcher/"
TMP_OUTPUT_FILE=${TMP_OUTPUT_PATH}/tmp_file
mkdir -p ${TMP_OUTPUT_PATH}

counter=1
for inputFile in $inputList
do
    outputPath=${TMP_OUTPUT_PATH}/output${counter}.txt

    START_TIME=$(getTime)
    ${start_program_cmd} < $inputFile > $outputPath
    END_TIME=$(getTime)

    timeElapsed=$(($END_TIME - $START_TIME))

    sed -e '$a\'  ${outputList[$((counter - 1))]} > ${TMP_OUTPUT_FILE}
    if [ -z "$(diff $TMP_OUTPUT_FILE $outputPath)" ]
    then
        setGreen
        echo -e "✓ Test #$counter (${timeElapsed} ms) "
        setDefaultColor
    else
        setRed
        echo "✗ Test #$counter"
        setDefaultColor
        echo -e "\tYOU:\t\t$(cat $outputPath)"
        echo -e "\tEXPECTED:\t$(cat $TMP_OUTPUT_FILE)"
    fi

    counter=$((counter+1))
done

rm -r $TMP_OUTPUT_PATH