module ApplicationHelper
  require 'redcarpet'
  require 'redcarpet/render_strip'

  def markdown(text)
    return if text.nil?

    render_options = {
      filter_html: true,
      hard_wrap: true,
      space_after_headers: true,
      fenced_code_blocks: true,
    }
    renderer = Redcarpet::Render::HTML.new(render_options)

    extensions = {
      tables: true,
      tasklist: true,
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_spacing: true,
      strikethrough: true,
      superscript: true,
      quote: true,
      footnotes: true,
    }
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    sanitize markdown.render(text)
  end
end
