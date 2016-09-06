module CardInfo
  extend ActiveSupport::Concern

  def get_class_info
    logger.info "Running get_class_info"
    name = params[:class_selected].gsub(/_select/,'')
    class_info = ClassCard.where(name: name).first

    logger.info "class_info: #{class_info.inspect}"

    render json: class_info
  end

end
