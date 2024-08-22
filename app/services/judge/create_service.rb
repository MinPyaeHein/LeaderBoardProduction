class Judge::CreateService
  def initialize(params)
    @params = params
  end

  def create
    judges = []
    errors = []

    @params[:member_ids].each do |member_id|
      result = check_judge(member_id)

      if result[:errors].present?
        errors.concat(result[:errors])
      else
        judge = create_judge(member_id)
        if judge.persisted?
          judges << judge
        else
          errors.concat(judge.errors.full_messages)
        end
      end
    end

    {success: true,message:{ judges: judges, errors: errors }}
  end

  private

  def check_judge(member_id)
    member = Member.includes(:users).find_by(id: member_id, active: true)

    if member.nil?
      return { errors: ["Member does not exist in the database."] }
    end

    existing_judge = ::Judge.find_by(member_id: member_id, event_id: @params[:event_id], active: true)
    if existing_judge.present?
      user_email = member.users.first&.email
      return { errors: ["This judge "+user_email+" already part of the this Event."] }
    end

    existing_team_mamber = ::TeamMember.find_by(member_id: member_id, event_id: @params[:event_id], active: true)
    if existing_team_mamber.present?
      user_email = member.users.first&.email
      return { errors: ["A Team member cannot become a Judge",member.name] }
    end

    {}
  end

  def create_judge(member_id)
    investor_matrix = InvestorMatrix.find_by(event_id: @params[:event_id], investor_type: @params[:judge_type])
    @params[:current_amount] = investor_matrix&.judge_acc_amount if investor_matrix.present?

    ::Judge.create(
      member_id: member_id,
      event_id: @params[:event_id],
      active: @params[:active],
      judge_type: @params[:judge_type],
      current_amount: @params[:current_amount]
    )
  end
end
