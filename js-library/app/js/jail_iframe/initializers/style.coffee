`var style_code = __INLINE_CSS_PLACEHOLDER__;`

style_el = document.createElement('style')
style_el.appendChild(document.createTextNode(style_code))

$('head').prepend style_el
