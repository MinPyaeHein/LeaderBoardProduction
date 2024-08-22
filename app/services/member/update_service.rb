class Member::UpdateService
  def initialize(params)
    @params = params
  end

  def update
    @member = ::Member.find(@params[:member_id]) # Assuming you're updating an existing member
    if @member.nil?
      return { errors: ["Member not found"] }
    end

    # Retain old values if new ones are null
    @member.assign_attributes(
      name: @params[:name] || @member.name,
      phone: @params[:phone] || @member.phone,
      address: @params[:address] || @member.address,
      desc: @params[:desc] || @member.desc,
      faculty_id: @params[:faculty_id] || @member.faculty_id,
      org_name: @params[:org_name] || @member.org_name,
      profile_url: @params[:profile_url] || @member.profile_url,
      active: @params[:active].nil? ? @member.active : @params[:active]
    )

    if @member.save
      { member: @member.reload } # Reload to get the latest data
    else
      { errors: @member.errors.full_messages }
    end
  end
end
