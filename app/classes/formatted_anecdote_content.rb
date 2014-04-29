class FormattedAnecdoteContent
  include ActionView::Helpers::TagHelper

  def initialize text
    @anecdote = JSON.parse(text)
  end

  def html
    (content_tag(:p, content_tag(:strong, 'Introduction')) +
      content_tag(:p, @anecdote['introduction']) +
      content_tag(:p, content_tag(:strong, 'Sudden insight')) +
      content_tag(:p, @anecdote['insight']) +
      content_tag(:p, content_tag(:strong, 'Resources')) +
      content_tag(:p, @anecdote['resources']) +
      content_tag(:p, content_tag(:strong, 'Actions')) +
      content_tag(:p, @anecdote['actions']) +
      content_tag(:p, content_tag(:strong, 'Effect + evaluation')) +
      content_tag(:p, @anecdote['effect'])).html_safe
  end
end
