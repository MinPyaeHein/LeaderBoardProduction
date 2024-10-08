class TranInvestor::CreateService
  def initialize(params,current_user)
    @params = params
    @current_user=current_user
  end

  def create
    invest_matrix = InvestorMatrix.find_by(event_id: @params[:event_id], investor_type: @params[:investor_type])
    team_event = TeamEvent.find_by(event_id: @params[:event_id], team_id: @params[:team_id])
    judge = Judge.find_by(member_id: @current_user.member_id, event_id: @params[:event_id], judge_type: @params[:investor_type])

    return { success: false,message:{ errors: "Team Event not found in the database" } }if team_event.nil?
    return { success: false,message:{errors: "Investor Matrix not found for the given event and investor type" } }if invest_matrix.nil?
    return { success: false,message:{ errors: "Judge not found for the given event and investor type" }} if judge.nil?

    case @params[:tran_type]
    when "add"
      handle_add_transaction(judge, invest_matrix, team_event)
    when "sub"
      handle_subtract_transaction(judge, invest_matrix, team_event)
    else
      { errors: ["Invalid transaction type"] }
    end
  end

  def create_initial_tran(event_id, team_id)
    team_event = TeamEvent.find_by(event_id: event_id, team_id: team_id)
    return { success: false,message: {errors: "Team event not found" } }if team_event.nil?

    tran_investor = TranInvestor.new(
      amount: 0.0,
      judge_id: 4,
      team_event_id: team_event.id,
      event_id: event_id
    )

    if tran_investor.save
      {success: false,message:{tranInvestor: tran_investor }}
    else
      { errors: tran_investor.errors.full_messages }
    end
  end

  private

  def handle_add_transaction(judge, invest_matrix, team_event)
    if judge.current_amount - invest_matrix.one_time_pay < 0
     return {success: false,message: { errors: "Insufficient Judge Account Balance" }}
    else
      create_transaction(judge, invest_matrix, team_event, invest_matrix.one_time_pay)
    end
  end

  def handle_subtract_transaction(judge, invest_matrix, team_event)
    total_investment = TranInvestor.where(event_id: @params[:event_id], judge_id: judge.id, team_event_id: team_event.id).sum(:amount)

    if total_investment - invest_matrix.one_time_pay < 0
      { success: false ,message:{errors: "You should not subtract investment amount more than you invested!" }}
    else
      create_transaction(judge, invest_matrix, team_event, -invest_matrix.one_time_pay)
    end
  end

  def create_transaction(judge, invest_matrix, team_event, amount)
    tran_investor = TranInvestor.new(
      amount: amount,
      judge_id: judge.id,
      team_event_id: team_event.id,
      event_id: @params[:event_id]
    )

    if tran_investor.save
      update_judge_balance(judge, invest_matrix.one_time_pay * (amount.positive? ? -1 : 1))
      {success: true,message:{ tranInvestor: tran_investor, judge: judge.reload }}
    else
      {success: false,message:{ errors: tran_investor.errors.full_messages }}
    end
  end

  def update_judge_balance(judge, adjustment_amount)
    judge.update(current_amount: judge.current_amount + adjustment_amount)
  end
end
