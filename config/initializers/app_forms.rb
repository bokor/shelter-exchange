# Makes the field_with_errors not show up
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| html_tag.html_safe }