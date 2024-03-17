class BaseViewComponent < ViewComponent::Base
  class << self
    # We need separate channel for round/user
    def round_per_user_dom_id(round_id, user_id)
      "round_#{round_id}_user_#{user_id}"
    end

    # Repeating logic of dom_id
    def round_dom_id(round_id)
      "round_#{round_id}"
    end

    # Repeating logic of dom_id
    def round_user_dom_id(round_user_id)
      "round_user_#{round_user_id}"
    end
  end
end
