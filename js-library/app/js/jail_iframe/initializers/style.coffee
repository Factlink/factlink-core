`var style_code = __INLINE_CODE_FROM_GRUNT__;`

style_el = document.createElement('style')
style_el.appendChild(document.createTextNode(style_code))

$('head').prepend style_el
