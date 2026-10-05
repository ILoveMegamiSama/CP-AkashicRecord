#import "../templates/book_theme.typ": book-setup

#show: book-setup.with(
  title: "Lập Trình Thi Đấu C++14",
  volume: "Tập 1: Nền Tảng C++14 & Tư Duy Bộ Nhớ",
  author: "Akashic Record",
)

#include "chapters/ch01.typ"
#pagebreak()
#include "chapters/ch02.typ"
#pagebreak()
#include "chapters/ch03.typ"
#pagebreak()
#include "chapters/ch04.typ"
#pagebreak()
#include "chapters/ch05.typ"
#pagebreak()
#include "chapters/ch06.typ"
#pagebreak()
#include "chapters/ch07.typ"
#pagebreak()
#include "chapters/ch08.typ"
#pagebreak()
#include "chapters/integrated.typ"
#pagebreak()
#include "appendix.typ"
