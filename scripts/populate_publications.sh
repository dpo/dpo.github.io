#!/bin/bash

TOP=$(PWD)
BIB_LOCATION="publications"
PUB_HEADER="${TOP}/publications.qmd"
PUB_BODY="${TOP}/publications_body.qmd"

function begin_yaml_header () {
cat << EOF
---
title: "Publications"
bibliography:
EOF
}

function end_yaml_header () {
cat << EOF
validate-yaml: false
csl: "apa-cv"
nocite: "[@*]"
---
EOF
}

function publications_header () {
cat << EOF

## Publications

EOF
}

function add_include_statement () {
  echo
  echo "{{< include publications_body.qmd >}}"
}

function add_article_entry_to_header () {  # arg1 = year
  echo "    articles$1: ${BIB_LOCATION}/articles$1.bib"
}

function add_tech_report_entry_to_header () {
  echo "    techrep$1: ${BIB_LOCATION}/techrep$1.bib"
}

function add_proceedings_entry_to_header () {
  echo "    proceedings$1: ${BIB_LOCATION}/proceedings$1.bib"
}

function add_unpublished_entry_to_header () {
  echo "    unpublished$1: ${BIB_LOCATION}/unpublished$1.bib"
}

function add_books_entry_to_header () {
  echo "    books$1: ${BIB_LOCATION}/books$1.bib"
}

function add_year_div_to_body () {  # arg1 = year
cat << EOF
## $1

EOF
}

function add_articles_to_body () {  # arg1 = year
cat << EOF
### Journal Articles

::: {#refs-articles$1}
:::

EOF
}

function add_techrep_to_body () {  # arg1 = year
cat << EOF
### Technical Reports

::: {#refs-techrep$1}
:::

EOF
}

function add_books_to_body () {  # arg1 = year
cat << EOF
### Books

::: {#refs-books$1}
:::

EOF
}

function add_proceedings_to_body () {  # arg1 = year
cat << EOF
### Proceedings

::: {#refs-proceedings$1}
:::

EOF
}

function add_unpublished_to_body () {  # arg1 = year
cat << EOF
### Unpublished

::: {#refs-unpublished$1}
:::

EOF
}

function main () {
  cd $BIB_LOCATION
  begin_yaml_header > $PUB_HEADER
  echo "" > $PUB_BODY
  for year in $(seq $(date +"%Y") 2000)
  do
    has_books=$([[ -f books${year}.bib ]] && echo "1" || echo "0")
    has_articles=$([[ -f articles${year}.bib ]] && echo "1" || echo "0")
    has_proceedings=$([[ -f proceedings${year}.bib ]] && echo "1" || echo "0")
    has_techrep=$([[ -f techrep${year}.bib ]] && echo "1" || echo "0")
    has_unpublished=$([[ -f unpublished${year}.bib ]] && echo "1" || echo "0")
    if [[ "$has_books" == "1" || "$has_articles" == "1" || "$has_proceedings" == "1" || "$has_techrep" == "1" || "$has_unpublished" == "1" ]]; then
      add_year_div_to_body $year >> $PUB_BODY
    fi
    if [ "$has_books" == "1" ]; then
      add_books_entry_to_header $year >> $PUB_HEADER
      add_books_to_body $year >> $PUB_BODY
    fi
    if [ "$has_articles" == "1" ]; then
      add_article_entry_to_header $year >> $PUB_HEADER
      add_articles_to_body $year >> $PUB_BODY
    fi
    if [ "$has_proceedings" == "1" ]; then
      add_proceedings_entry_to_header $year >> $PUB_HEADER
      add_proceedings_to_body $year >> $PUB_BODY
    fi
    if [ "$has_techrep" == "1" ]; then
      add_tech_report_entry_to_header $year >> $PUB_HEADER
      add_techrep_to_body $year >> $PUB_BODY
    fi
    if [ "$has_unpublished" == "1" ]; then
      add_unpublished_entry_to_header $year >> $PUB_HEADER
      add_unpublished_to_body $year >> $PUB_BODY
    fi
  done
  end_yaml_header >> $PUB_HEADER
  add_include_statement >> $PUB_HEADER
  cd $TOP
}

main
