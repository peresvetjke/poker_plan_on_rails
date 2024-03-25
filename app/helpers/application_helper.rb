# frozen_string_literal: true

module ApplicationHelper
  def shorten(text)
    text&.truncate(40, separator: /\s/)
  end
end
