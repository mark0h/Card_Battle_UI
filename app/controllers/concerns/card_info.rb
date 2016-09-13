module CardInfo
  extend ActiveSupport::Concern

  def get_class_info
    logger.info "Running get_class_info"
    selected_id = params[:class_selected].gsub(/_select/,'').to_i
    @class_info = ClassCard.find(selected_id)

    logger.info "class_info: #{@class_info.inspect}"

    render json: @class_info
  end

  def get_opponent_info
    logger.info "Running get_class_info"
    selected_id = params[:opponent_selected].gsub(/_opponent/,'').to_i
    @opponent_info = ClassCard.find(selected_id)


    logger.info "opponent_info: #{@opponent_info.inspect}"

    render json: @opponent_info
  end

  # ------------------------------
  #   CLASS SELECTION MENU METHODS
  # ------------------------------

  def selected_class_cards
    logger.info "class_info: #{params[:class_selected_id]}"
    @class_deck = SkillCard.where(class_id: params[:class_selected_id])
    render "user/_class_selected",
         locals: { selected_class: @class_deck },
         layout: false
  end

  def opponent_class_cards
    logger.info "class_info: #{params[:opponent_selected_id]}"
    @opponent_deck = SkillCard.where(class_id: params[:opponent_selected_id])
    render "user/_class_selected",
         locals: { selected_class: @opponent_deck },
         layout: false
  end

end
