class HtmlEditor
  def initialize(html)
    @html = html
  end

  def prepend_to_head addition
    @html = @html.sub regex_skip_until_in_html_head do
      $& + addition
    end
  end

  def to_s
    @html
  end

  private

  # We want to inject stuff into the <head>, but <head> may be implicit.
  # Though a <head> must officially have a <title>, omitting it doesn't break browsers, so what to detect?
  # Officially, every head needs a <title>, but invalid docs might omit it.  However, every head
  # needs *some* tag; we can just match the first tag that's not <head> or <html> - if a head really is empty, we'll match the closing </head> or <body> tags.
  #
  # Strategy: skip everything that's not a tag in the head:
  #  1. non '<' characters can be skipped; they're not interesting
  #  2. full comments <! -- comment --> can be skipped
  #  3. <head or <html can be skipped.
  #  4. <??? can be skipped when ??? isn't a closing tag so doesn't start with '/' and isn't an opening tag so doesn't start with 'a'-'z'
  # After this match we can't consume tokens and so must be at:
  # - the end of the document OR
  # - some string starting with '<' due to rule 1
  # -- BUT NOT a comment
  # -- AND NOT <html or <head
  # -- AND at a starting or closing tag.
  def regex_skip_until_in_html_head
    /(?:[^<]|<(?:!\s*--(?:(?!-->).)*-->|html|head|[^a-z\/]))*/i
  end
end
