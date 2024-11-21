function Div(el)
  if el.classes:includes('leftpanel') then
    local blocks = pandoc.List({
      pandoc.RawBlock('typst', '#leftpanel[')
    })
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock('typst', ']\n'))
    return blocks
  elseif el.classes:includes('rightpanel') then
    local blocks = pandoc.List({
      pandoc.RawBlock('typst', '#rightpanel[')
    })
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock('typst', ']\n'))
    return blocks
  end
end