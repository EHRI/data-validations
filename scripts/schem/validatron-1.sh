#!/bin/sh

# path to xsltproc executable
xsltproc="/usr/bin/xsltproc"

# paths to reference implementation xslt scripts
stage_1_xslt="./ref-imp-1/iso_dsdl_include.xsl"
stage_2_xslt="./ref-imp-1/iso_abstract_expand.xsl"
stage_3_xslt="./ref-imp-1/iso_svrl_for_xslt1.xsl"

# check if xsltproc runs
$xsltproc --version > /dev/null
if [ $? -ne 0 ]
then
    echo "ERROR: failed to run xsltproc from \"$xsltproc\""
    exit 1
fi

# check arguments
if [ $# -ne 3 ]
then
    echo "USAGE: $0 <schematron schema> <input xml> <output svrl>"
    exit 1
fi

# stage 1: assemble schema from parts
$xsltproc --output "$1.st1" "$stage_1_xslt" "$1"
if [ $? -ne 0 ]
then
    echo "ERROR: failed to complete stage 1"
    exit 1
fi
echo "INFO: stage 1 completed"

# stage 2: convert abstract patterns
$xsltproc --output "$1.st2" "$stage_2_xslt" "$1.st1"
if [ $? -ne 0 ]
then
    echo "ERROR: failed to complete stage 2"
    rm "$1.st1"
    exit 1
fi
echo "INFO: stage 2 completed"

# stage 3: compile schema
$xsltproc --output "$1.xsl" "$stage_3_xslt" "$1.st2"
if [ $? -ne 0 ]
then
    echo "ERROR: failed to complete stage 3"
    rm "$1.st1" "$1.st2"
    exit 1
fi
echo "INFO: stage 3 completed"

# stage 4: validate input xml
$xsltproc --output "$3" "$1.xsl" "$2"
rm "$1.st1" "$1.st2"
if [ $? -ne 0 ]
then
    echo "ERROR: failed to complete stage 4"
    rm "$1.st1" "$1.st2"
    exit 1
fi
echo "INFO: stage 4 completed"
echo "INFO: compiled XSLT script written to \"$1.xsl\""

