# frozen_string_literal: true

class IconComponent < ApplicationComponent
  def initialize(type:, file_name: "#{type}.svg", size: '20x20', alt: type.to_s.humanize)
    @file_name = file_name
    @size = size
    @alt = alt
    super
  end
end
