class UsersList::Component < BaseViewComponent
  FRAME_TAG = 'users_list'.freeze

  def initialize(round_users:, voted_user_ids:, frame_tag: FRAME_TAG)
    @round_users = round_users
    @voted_user_ids = voted_user_ids
    @frame_tag = frame_tag
    super
  end

  def render_in(view_context)
    view_context.render(
      partial: 'components/users_list/component',
      locals: { round_users:, voted_user_ids:, frame_tag: }
    )
  end

  private

  attr_reader :round_users, :voted_user_ids, :frame_tag
end
