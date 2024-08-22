class Member::UpdateService
  def initialize(params)
    @params = params
  end

  def update
    @member = ::Member.find(@params[:member_id])

    # Filter out nil values from the params
    filtered_params = @params.reject { |_, value| value.nil? }

    # Assign attributes that are present
    @member.assign_attributes(filtered_params)

    if @member.save
      { member: @member.reload } # Reload to get the latest data
    else
      { errors: @member.errors.full_messages }
    end
  end
end
