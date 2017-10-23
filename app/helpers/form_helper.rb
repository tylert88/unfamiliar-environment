module FormHelper
  def errors_for(form)
    return unless form.object.errors.present?

    render :partial => "shared/form_errors", :locals => {:form => form}
  end
end
