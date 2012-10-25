window.htmlEscape = (str)->
    String(str).replace(/&/g, '&amp;').
                replace(/"/g, '&quot;').
                replace(/'/g, '&#39;').
                replace(/</g, '&lt;').
                replace(/>/g, '&gt;')

window.nlToBr = (str)-> str.replace(/\n/g, '<br />');

