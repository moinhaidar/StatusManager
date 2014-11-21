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
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
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
    # resource.update_attributes(password: params[:password])
    resource.password = params[:member][:password]
    resource.password_confirmation = params[:member][:password_confirmation]


    resource.valid?

    if resource.errors.empty?
      resource.save
      resource.confirm!
      sign_in resource
      #redirect_to new_member_session_path, notice: "You've successfully set the password, please login to continue"
    else
      render :edit
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
