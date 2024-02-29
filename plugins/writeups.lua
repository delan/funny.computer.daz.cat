data = Sys.read_file("site/index.in")
index = HTML.parse(data)

writeups = HTML.select(index, ".writeups a")
indices = {}
i = 1
while writeups[i] do
  href = HTML.get_attribute(writeups[i], "href")
  indices[href] = i
  i = i + 1
end

refs = HTML.select(page, "a.writeup")
i = 1
while refs[i] do
  href = HTML.get_attribute(refs[i], "href")
  text = HTML.create_text("[" .. indices[href] .. "]")
  HTML.replace_content(refs[i], text)
  i = i + 1
end
