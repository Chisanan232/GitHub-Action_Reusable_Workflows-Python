#!/usr/bin/env bash

set -ex

test_type=$1
test_coverage_report_format=$2
source_folder=${3:-src}  # Default to 'src' if not provided

coveragedatafile=".coverage.$test_type"

if [ "$test_type" == "all-test" ];
then
  coverage combine --data-file="$coveragedatafile" "$test_coverage_report_format"*
else
  coverage combine --data-file="$coveragedatafile" "$test_coverage_report_format$test_type"*
fi

# Get current working directory for path remapping
CURRENT_DIR=$(pwd)
echo "📂 Current directory: $CURRENT_DIR"
echo "📁 Source folder: $source_folder"

# Create .coveragerc to handle path remapping from macOS (/Users/) to Linux (/home/)
cat > .coveragerc << EOF
[paths]
source =
    $source_folder/
    ./$source_folder/
    */$source_folder/
    */*/$source_folder/
    /Users/runner/work/**/$source_folder/
    /home/runner/work/**/$source_folder/
EOF

echo "📝 Created .coveragerc for path remapping"
cat .coveragerc

coverage report -m --data-file="$coveragedatafile"
coverage xml --data-file="$coveragedatafile" -o coverage_"$test_type".xml
cp "$coveragedatafile" .coverage
echo "✅ All processing done." && exit 0
