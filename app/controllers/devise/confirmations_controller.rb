class Devise::ConfirmationsController < DeviseController
  # GET /resource/confirmation/new
  def new
    self.resource = resource_class.new
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource, original_token = resource_class.find_original_token(params[:confirmation_token])
    logger.info "======================="
    logger.info self.resource.inspect
    logger.info original_token.inspect
    logger.info "======================="
    return render :text => "Invalid Token" if self.resource.blank?
    redirect_to edit_member_confirmation_path(confirmation_token: original_token) and return
    # yield resource if block_given?
    #
    # if resource.errors.empty?
    #   set_flash_message(:notice, :confirmed) if is_flashing_format?
    #   respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    # else
    #   respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    # end
  end

  # GET /resource/edit
  def edit
    self.resource = resource_class.where(confirmation_token: params[:confirmation_token]).first
    redirect_to new_member_registration_path, notice: "Invalid Token" unless resource
  end

  # PUT /resource/confirmation
  def update
    self.resource = resource_class.where(confirmation_token: params[:member][:confirmation_token]).first
    unless resource
      redirect_to new_member_registration_path, notice: "Invalid Token"
      return
    end

    if resource.update_password_with_confirmation(params[:member])
      sign_in resource
      redirect_to dashboard_path, notice: "You have been successfully confirmed"
    else
      render :edit, confirmation_token: params[:confirmation_token]
    end

  end

#-------------------------------------------------------------------------------------------------------------------

  protected

    # The path used after resending confirmation instructions.
    def after_resending_confirmation_instructions_path_for(resource_name)
      is_navigational_format? ? new_session_path(resource_name) : '/'
    end

    # The path used after confirmation.
    def after_confirmation_path_for(resource_name, resource)
      if signed_in?(resource_name)
        signed_in_root_path(resource)
      else
        new_session_path(resource_name)
      end
    end
end
