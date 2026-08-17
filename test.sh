#!/usr/bin/env bash
set -u

echo "=============================================="
echo " Ex11 - Fourth Paragraph Mail Link Autograder"
echo " Total Marks: 50"
echo "=============================================="

MARKS=0

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
# Accept the CSS in the expected styles folder OR in the repository root.
if [ -f styles/Ex11_addparagraph.css ] || [ -f Ex11_addparagraph.css ]; then
    pass_test "CSS file found" 5
else
    fail_test "Ex11_addparagraph.css not found"
fi

if [ -f index.html ]; then

    # TEST 3 - HTML5 DOCTYPE
    if grep -qi '<!DOCTYPE html>' index.html; then
        pass_test "HTML5 DOCTYPE found" 5
    else
        fail_test "HTML5 DOCTYPE not found"
    fi

    # TEST 4 - Required article
    if grep -qi '<article>' index.html; then
        pass_test "article element found" 5
    else
        fail_test "article element not found"
    fi

    # TEST 5 - FOURTH PARAGRAPH MUST BE THE EMAIL/LINK PARAGRAPH
    # Extract paragraph tags inside article.
    FOURTH_P=$(awk '
        /<article>/ {inside=1}
        /<\/article>/ {inside=0}
        inside && /<p>/ {
            count++
            if (count == 4) print
        }
    ' index.html)

    if [ -n "$FOURTH_P" ]; then
        pass_test "Fourth paragraph found inside article" 5
    else
        fail_test "Fourth paragraph not found inside article"
    fi

    # TEST 6 - Fourth paragraph contains mail link
    FOURTH_BLOCK=$(awk '
        /<article>/ {inside=1}
        /<\/article>/ {inside=0}
        inside && /<p>/ {count++}
        inside && count==4 {print}
    ' index.html)

    # The test also checks the following lines until </p>, because the
    # mailto link may be on a separate line.
    FOURTH_BLOCK=$(awk '
        /<article>/ {inside=1}
        /<\/article>/ {inside=0}
        inside && /<p>/ {count++}
        inside && count==4 {capture=1}
        capture {print}
        capture && /<\/p>/ {exit}
    ' index.html)

    if echo "$FOURTH_BLOCK" | grep -qi 'mailto:' && \
       echo "$FOURTH_BLOCK" | grep -qi 'email us'; then
        pass_test "Fourth paragraph contains a mail link" 10
    else
        fail_test "Fourth paragraph is not a mail link paragraph"
    fi

    # TEST 7 - Required mail address
    if echo "$FOURTH_BLOCK" | grep -qi 'elenor@townhall.com'; then
        pass_test "Required email address found" 5
    else
        fail_test "Required email address not found in fourth paragraph"
    fi

    # TEST 8 - Original page structure retained
    if grep -qi '<header>' index.html && \
       grep -qi '<main>' index.html && \
       grep -qi '<section>' index.html && \
       grep -qi '<aside>' index.html && \
       grep -qi '<footer>' index.html; then
        pass_test "Original semantic structure retained" 5
    else
        fail_test "Required semantic elements are missing"
    fi

    # TEST 9 - Original speaker content retained
    if grep -qi 'Scott Sampson' index.html && \
       grep -qi 'Fossil Threads in the Web of Life' index.html; then
        pass_test "Original speaker content retained" 5
    else
        fail_test "Original speaker content missing"
    fi
fi

echo "----------------------------------------------"
echo "FINAL SCORE: $MARKS / 50"
echo "----------------------------------------------"

if [ "$MARKS" -eq 50 ]; then
    echo "RESULT: PASS"
    exit 0
else
    echo "RESULT: NEEDS IMPROVEMENT"
    exit 1
fi
