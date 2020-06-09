build:
  ./process_book_html.py
  ./epub.py
  just check

check:
  epubcheck information-retrieval.epub