# frozen_string_literal: true

module ApplicationHelper
  def render_turbo_stream_flash_messages
    turbo_stream.prepend 'flash', partial: 'layouts/flash'
  end

  def round_user_channel(round_id, user_id)
    "round_#{round_id}_user_#{user_id}"
  end

  def round_channel(round_id)
    "round_#{round_id}"
  end

  def round_user_frame_tag(round_user_id)
    "round_user_#{round_user_id}"
  end

  def estimation_panel_frame_tag
    'estimation_panel'
  end

  def users_list_frame_tag
    'users_list'
  end
end
