class Api::V1::W::DeviceController < Api::V1::W::BaseController
  # before_action { @device = current_device }
  # authorize_resource :simple_device, singleton: true
  skip_authorization_check

end