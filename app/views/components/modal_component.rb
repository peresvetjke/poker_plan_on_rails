# frozen_string_literal: true

class ModalComponent < ViewComponent::Base
  use_helpers :turbo_frame_tag

  renders_one :title
  renders_one :body
end
