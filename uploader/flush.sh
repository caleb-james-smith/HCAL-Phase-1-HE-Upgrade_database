#!/bin/bash

###################################################
#               Set Initial Data                  #
###################################################
echo -e "\e[1;34mSetting initial data"

scriptLoc=$(readlink -f $(dirname $0) )
jsonStore=$scriptLoc/temp_json
logLoc=$scriptLoc/log_files
hrLogLoc=$scriptLoc/../media/human_readable_logs
uhtrLoc=$scriptLoc/uhtr_results

rm -f $logLoc/*.log

remoteHost=hep@cmshcal12
remoteLoc=/home/hep/jsonResults
remoteHRLog=/home/hep/logResults
remoteUHTR=/home/hep/uhtrResults

STATUS="\e[1;34m"
ACTION="\e[1;33m"
SUCCESS="\e[1;92m"
FAIL="\e[1;91m"
DEF="\e[39;0m"

echo -e "${STATUS}Initial data set"
echo ""
###################################################
#            Make Tarballs for uHTR               #
###################################################
echo -e "${STATUS}Making Tarballs"
folderList=$(ls $uhtrLoc/ci_plots)
for file in $folderList
do
    echo -e "    ${ACTION}Processing${DEF} $(basename $file)"
    tar -zcf $jsonStore/ci_plot$(basename $file).tar.gz -C $uhtrLoc/ci_plots/ $file
done
folderList=$(ls $uhtrLoc/ped_plots)
for file in $folderList
do
    echo -e "    ${ACTION}Processing${DEF} $(basename $file)"
    tar -zcf $jsonStore/ped_plot$(basename $file).tar.gz -C $uhtrLoc/ped_plots/ $file
done

echo -e "    ${ACTION}Processing${DEF} histo_statistics"
tar -zcf $jsonStore/histostats.tar.gz -C $uhtrLoc/ histo_statistics

echo -e "${STATUS}Tarballs made"
echo ""
###################################################
#           Register Step 1 Tests                 #
###################################################
echo -e "${STATUS}Uploading step 1 tests"

if ls $jsonStore/*step1_raw.json &> /dev/null
then
    fileList=$(ls $jsonStore/*step1_raw.json)
    for file in $fileList
    do
        echo -e "    ${ACTION}Processing${DEF} $(basename $file)"
        python $scriptLoc/step1.py $file 2> $file.log

        if [ $? -eq 0 ]
        then
            echo -e "      ${SUCCESS}Success"
            rm $file*
        else
            echo -e "      ${FAIL}ERROR${DEF} (see $(basename $file).log)"
        fi
    done
else
    echo -e "    ${SUCCESS}No step 1 tests to upload"
fi

echo -e "${STATUS}New step 1 tests uploaded"
echo ""
###################################################
#           Register Step 2 Tests                 #
###################################################
echo -e "${STATUS}Uploading step 2 tests"

if ls $jsonStore/*step2_raw.json &> /dev/null
then
    fileList=$(ls $jsonStore/*step2_raw.json)
    for file in $fileList
    do
        echo -e "    ${ACTION}Processing${DEF} $(basename $file)"
        python $scriptLoc/step2.py $file 2> $file.log

        if [ $? -eq 0 ]
        then
            echo -e "      ${SUCCESS}Success"
            rm $file*
        else
            echo -e "      ${FAIL}ERROR${DEF} (see $(basename $file).log)"
        fi
    done
else
    echo -e "    ${SUCCESS}No step 2 tests to upload"
fi

echo -e "${STATUS}New step 2 tests uploaded"
echo ""
###################################################
#           Register QIE Tests                    #
###################################################
echo -e "${STATUS}Uploading QIE tests"

if ls $jsonStore/*test_raw.json &> /dev/null
then
    fileList=$(ls $jsonStore/*test_raw.json )
    for file in $fileList
    do
        echo -e "    ${ACTION}Processing${DEF} $(basename $file)"
        python $scriptLoc/test_upload.py $file 2> $file.log

        if [ $? -eq 0 ]
        then
            echo -e "      ${SUCCESS}Success"
            rm $file*
        else
            echo -e "      ${FAIL}ERROR${DEF} (see $(basename $file).log)"
        fi
    done
else
    echo -e "    ${SUCCESS}No tests to upload"
fi

echo -e "${STATUS}QIE tests uploaded"
echo ""
###################################################
#           Register uHTR Tests                   #
###################################################
echo -e "${STATUS}Uploading uHTR tests"

if ls $jsonStore/*test_uhtr.json &> /dev/null
then
    fileList=$(ls $jsonStore/*test_uhtr.json )
    for file in $fileList
    do
        echo -e "    ${ACTION}Processing${DEF} $(basename $file)"
        python $scriptLoc/uhtr_upload.py $file 2> $file.log

        if [ $? -eq 0 ]
        then
            echo -e "      ${SUCCESS}Success"
            rm $file*
        else
            echo -e "      ${FAIL}ERROR${DEF} (see $(basename $file).log)"
        fi
    done
else
    echo -e "    ${SUCCESS}No tests to upload"
fi

echo -e "${STATUS}uHTR tests uploaded"
echo ""


# Move log files to proper folder
mv $jsonStore/*.log $logLoc 2> /dev/null

echo -e "${STATUS}Finished${DEF}"

