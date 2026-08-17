#!/usr/bin/env bash
set -u

echo "=============================================="
echo " Ex11 - Add Paragraph Autograder"
echo " Total Marks: 50"
echo "=============================================="

MARKS=0
TOTAL=50

pass_test() {
    echo "PASS - $1 - $2 marks"
    MARKS=$((MARKS + $2))
}

fail_test() {
    echo "FAIL - $1 - 0 marks"
}

# TEST 1 - HTML file
if [ -f index.html ]; then
    pass_test "index.html found" 5
else
    fail_test "index.html not found"
fi

# TEST 2 - CSS file
if [ -f styles/Ex11_addparagraph.css ]; then
    pass_test "CSS file found" 5
else
    fail_test "styles/Ex11_addparagraph.css not found"
fi

if [ -f index.html ]; then
    # TEST 3 - DOCTYPE
    if grep -qi '<!DOCTYPE html>' index.html; then
        pass_test "HTML5 DOCTYPE found" 5
    else
        fail_test "HTML5 DOCTYPE not found"
    fi

    # TEST 4 - article
    if grep -qi '<article>' index.html; then
        pass_test "article element found" 5
    else
        fail_test "article element not found"
    fi

    # TEST 5 - four biography paragraphs
    BIO_COUNT=$(awk '
        /<article>/ {in_article=1}
        /<\/article>/ {in_article=0}
        in_article && /<p>/ {count++}
        END {print count+0}
    ' index.html)

    if [ "$BIO_COUNT" -ge 5 ]; then
        pass_test "Required additional paragraph added" 10
    else
        fail_test "Additional biography paragraph missing (found $BIO_COUNT article paragraphs; expected at least 5 including the luncheon paragraph)"
    fi

    # TEST 6 - required paragraph content
    if grep -qi "In addition to his museum and laboratory-based studies" index.html && \
       grep -qi "Zimbabwe, South Africa, and Madagascar" index.html; then
        pass_test "New paragraph contains required Sampson information" 10
    else
        fail_test "New paragraph content is missing or incomplete"
    fi

    # TEST 7 - original page structure retained
    if grep -qi '<header>' index.html && \
       grep -qi '<main>' index.html && \
       grep -qi '<section>' index.html && \
       grep -qi '<aside>' index.html && \
       grep -qi '<footer>' index.html; then
        pass_test "Original semantic page structure retained" 5
    else
        fail_test "One or more required semantic elements are missing"
    fi

    # TEST 8 - Scott Sampson heading retained
    if grep -qi "Scott Sampson" index.html && \
       grep -qi "Fossil Threads in the Web of Life" index.html; then
        pass_test "Original speaker content retained" 5
    else
        fail_test "Original speaker content was changed or removed"
    fi
fi

echo "----------------------------------------------"
echo "FINAL SCORE: $MARKS / $TOTAL"
echo "----------------------------------------------"

if [ "$MARKS" -eq "$TOTAL" ]; then
    echo "RESULT: PASS"
    exit 0
else
    echo "RESULT: NEEDS IMPROVEMENT"
    exit 1
fi
