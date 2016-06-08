#!/bin/sh

# path to java executable
java="/usr/bin/java"

# path to saxon jar
saxon_jar="saxon9he.jar"

# paths to reference implementation xslt scripts
stage_1_xslt="./ref-imp-2/iso_dsdl_include.xsl"
stage_2_xslt="./ref-imp-2/iso_abstract_expand.xsl"
stage_3_xslt="./ref-imp-2/iso_svrl_for_xslt2.xsl"

# check if java runs
$java -version 2> /dev/null
if [ $? -ne 0 ]
then
    echo "ERROR: failed to run java from \"$java\""
    exit 1
fi

# check if saxon jar exists
if [ ! -f $saxon_jar ]
then
    echo "ERROR: cannot access saxon jar at \"$saxon_jar\"";
    exit 1
fi

# check arguments
if [ $# -ne 3 ]
then
    echo "USAGE: $0 <schematron schema> <input xml> <output svrl>"
    exit 1
fi

# stage 1: assemble schema from parts
$java -jar $saxon_jar -xsltversion:2.0 -xsl:"$stage_1_xslt" -s:"$1" -o:"$1.st1"
if [ $? -ne 0 ]
then
    echo "ERROR: failed to complete stage 1"
    exit 1
fi
echo "INFO: stage 1 completed"

# stage 2: convert abstract patterns
$java -jar $saxon_jar -xsltversion:2.0 -xsl:"$stage_2_xslt" -s:"$1.st1" -o:"$1.st2"
if [ $? -ne 0 ]
then
    echo "ERROR: failed to complete stage 2"
    rm "$1.st1"
    exit 1
fi
echo "INFO: stage 2 completed"

# stage 3: compile schema
$java -jar $saxon_jar -xsltversion:2.0 -xsl:"$stage_3_xslt" -s:"$1.st2" -o:"$1.xsl"
if [ $? -ne 0 ]
then
    echo "ERROR: failed to complete stage 3"
    rm "$1.st1" "$1.st2"
    exit 1
fi
echo "INFO: stage 3 completed"

# stage 4: validate input xml
$java -jar $saxon_jar -xsltversion:2.0 -xsl:"$1.xsl" -s:"$2" -o:"$3"
rm "$1.st1" "$1.st2"
if [ $? -ne 0 ]
then
    echo "ERROR: failed to complete stage 4"
    rm "$1.st1" "$1.st2"
    exit 1
fi
echo "INFO: stage 4 completed"
echo "INFO: compiled XSLT script written to \"$1.xsl\""

