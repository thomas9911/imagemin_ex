# because of the side effects I thought it is easier to write a bash script to test it.
# (also we don't have test the imagemin-cli itself)

IN_FILE="test/manual_test/example.jpg"
FILE="test.jpg"
mix run -e "ImageminEx.convert(\"$IN_FILE\", \"$FILE\")"

if [ -f "$FILE" ]; then
    myfilesize=$(wc -c "$FILE" | awk '{print $1}')
    if [ "$myfilesize" = "0" ]; then 
        echo "File is empty"
        exit 1
    else
        echo "$FILE exists and is valid."
        rm $FILE
    fi
else
    echo "Test failed"
    exit 1
fi
